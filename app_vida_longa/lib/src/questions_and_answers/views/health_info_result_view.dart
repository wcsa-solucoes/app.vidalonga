import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:gal/gal.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:screenshot/screenshot.dart';


import 'package:app_vida_longa/shared/widgets/custom_scaffold.dart';
import 'package:app_vida_longa/shared/widgets/default_app_bar.dart';
import 'package:app_vida_longa/shared/widgets/default_text.dart';
import 'package:app_vida_longa/domain/contants/app_colors.dart';

class HealthInfoResultView extends StatefulWidget {
  const HealthInfoResultView({super.key});

  @override
  State<HealthInfoResultView> createState() => _HealthInfoResultViewState();
}

class _HealthInfoResultViewState extends State<HealthInfoResultView> {
  final ScreenshotController _screenshotController = ScreenshotController();
  bool _isLoading = false;

  // TODO verificart corretamente o json, porque a seleção não diz respeito a somar as informações de ambos é diferente
  // TODO analise cuidadosamente o PDF, pois está faltando informações

  String _getProtocoloKey(List<String> selected) {
    // Normaliza texto: remove acentos, palavras "de", espaços e caracteres especiais
    String _norm(String s) {
      var out = s.toLowerCase();
      // Remover a palavra 'de' isolada
      out = out.replaceAll(RegExp(r'\bde\b'), '');
      // Substituições simples de acentos comuns
      const accents = {
        'á': 'a', 'à': 'a', 'â': 'a', 'ã': 'a', 'ä': 'a', 'Á': 'a', 'À': 'a', 'Â': 'a', 'Ã': 'a', 'Ä': 'a',
        'é': 'e', 'è': 'e', 'ê': 'e', 'É': 'e', 'È': 'e', 'Ê': 'e',
        'í': 'i', 'ì': 'i', 'î': 'i', 'Í': 'i', 'Ì': 'i', 'Î': 'i',
        'ó': 'o', 'ò': 'o', 'ô': 'o', 'õ': 'o', 'ö': 'o', 'Ó': 'o', 'Ò': 'o', 'Ô': 'o', 'Õ': 'o', 'Ö': 'o',
        'ú': 'u', 'ù': 'u', 'û': 'u', 'ü': 'u', 'Ú': 'u', 'Ù': 'u', 'Û': 'u', 'Ü': 'u',
        'ç': 'c', 'Ç': 'c', 'ñ': 'n', 'Ñ': 'n'
      };
      accents.forEach((k, v) {
        out = out.replaceAll(k, v);
      });
      // Remover quaisquer caracteres não alfanuméricos
      out = out.replaceAll(RegExp(r'[^a-z0-9]'), '');
      return out;
    }

    final sorted = List<String>.from(selected)..sort();

    if (sorted.length == 1) {
      final map = {
        "Insônia": "insonia",
        "Controle de peso": "controle_de_peso",
        "Ansiedade": "ansiedade",
      };
      return map[sorted[0]] ?? _norm(sorted[0]);
    }

    // Para combinações, tentamos formar uma chave normalizada que exista no JSON
    final normalizedKey = sorted.map(_norm).join('_');
    if (protocolosVidaLonga.containsKey(normalizedKey)) return normalizedKey;

    // Fallbacks: usar mapeamentos prévios por compatibilidade
    if (sorted.length == 2) {
      final key = sorted.join("_");
      final map = {
        "Ansiedade_Insônia": "ansiedade_insonia",
        "Controle de peso_Insônia": "controlepeso_insonia",
        "Ansiedade_Controle de peso": "controle_peso_ansiedade",
      };
      return map[key] ?? normalizedKey;
    }

    if (sorted.length == 3) {
      // chave presente no JSON
      if (protocolosVidaLonga.containsKey('controlepeso_ansiedade_insonia')) {
        return 'controlepeso_ansiedade_insonia';
      }
      return normalizedKey;
    }

    return _norm(sorted.join('_'));
  }

  static const Map<String, dynamic> protocolosVidaLonga = {
  "insonia": {
    "empresa": {
      "nome": "Vida Longa",
      "slogan": "Viva mais. Viva melhor"
    },
    "receita_manipulacao_sugestao": {
      "instrucoes": "PARA MANIPULAÇÃO (SUGESTÃO)",
      "quantidade_capsulas": "30 a 90 cápsulas",
      "tipo_capsula": "Vegetal",
      "conservantes": "Sem conservantes",
      "uso": "Contínuo",
      "posologia": {
        "instrucao": "Tomar 1 cápsula por via oral à noite, após as 20h.",
        "observacao": "Caso necessário, pode usar mais 1 ou 2 cápsulas."
      },
      "componentes": [
        {"nome": "VALERIANA", "dosagem": "100 mg"},
        {"nome": "CAMOMILA", "dosagem": "100 mg"},
        {"nome": "L TEANINA", "dosagem": "60 mg"},
        {"nome": "MELATONINA", "dosagem": "03 mg"},
        {"nome": "MAGNÉSIO QUELATO", "dosagem": "30 mg"}
      ],
      "indicacoes": "Fórmula destinada a auxiliar:",
      "beneficios": [
        "Melhora do sono",
        "Aumento da concentração",
        "Melhora do humor",
        "Proteção da memória",
        "Redução do estresse",
        "Redução da ansiedade"
      ]
    },
    "orientacoes_higiene_sono": {
      "titulo": "ORIENTAÇÕES DE HIGIENE DO SONO (Recomendado)",
      "orientacoes": [
        "Evitar telas (celular, computador, TV) 1 hora antes de dormir",
        "Preferir ambiente escuro e silencioso",
        "Evitar refeições pesadas à noite",
        "Manter horário regular de sono",
        "Praticar técnicas de relaxamento"
      ]
    },
    "sugestao_vida_longa_saudavel": {
      "titulo": "SUGESTÃO PARA UMA VIDA LONGA E SAUDÁVEL",
      "dica":
          "Cuide do sono, da alimentação, da atividade física e do bem-estar emocional diariamente."
    },
    "contato": "Caso ainda tenha dúvidas, faça sua pergunta no APP Vida Longa!"
  },
  "controle_de_peso": {
    "empresa": {"nome": "Vida Longa", "slogan": "Viva mais Viva melhor"},
    "receita_manipulacao_sugestao": {
      "instrucoes": "PARA MANIPULAÇÃO (SUGESTÃO)",
      "detalhes": {
        "quantidade_capsulas": "45 a 90 cápsulas",
        "tipo_capsula": "Vegetal",
        "conservantes": "Sem conservantes",
        "tratamento": "Uso contínuo até obtenção dos resultados desejados"
      },
      "posologia": {
        "instrucao":
            "Tomar 1 cápsula por via oral, duas vezes ao dia, após as 07h e após as 17h."
      },
      "componentes": [
        {"nome": "Vitamina D3", "dosagem": "1000 ui"},
        {"nome": "PICOLINATO DE CROMO", "dosagem": "150 mcg"},
        {"nome": "CAMOMILA", "dosagem": "30 mg"},
        {"nome": "L TRIPTOFANO", "dosagem": "50 mg"},
        {"nome": "ZINCO QUELATO", "dosagem": "05 mg"},
        {"nome": "MAGNÉSIO QUELATO", "dosagem": "30 mg"}
      ],
      "indicacao": "Fórmula desenvolvida para auxiliar:",
      "beneficios": [
        "Controle do apetite",
        "Melhora do humor e bem-estar",
        "Redução da ansiedade alimentar",
        "Suporte ao metabolismo",
        "Auxílio no emagrecimento saudável"
      ]
    },
    "plano_de_cuidados_controle_peso": {
      "titulo": "PLANO DE CUIDADOS - CONTROLE DE PESO",
      "evitar": {
        "itens": [
          "Açúcar e doces",
          "Excesso de sal",
          "Carne vermelha com frequência",
          "Alimentos ultraprocessados",
          "Gorduras saturadas (queijo coalho, manteiga)",
          "Frituras, inclusive no azeite",
          "Óleos em geral",
          "Massas e farináceos: pão, bolo, farinha, cuscuz, biscoitos, macarrão, pizza",
          "Café à noite",
          "Alimentação pesada no período noturno"
        ],
        "motivos_para_evitar_oleos_e_frituras":
            "agressão gástrica, aumento do colesterol, alta oxidação, formação de radicais livres, envelhecimento acelerado, aumento de risco cardiovascular e para câncer"
      },
      "preferencias_noturnas": {
        "titulo": "À noite preferir:",
        "itens":
            "Ovos cozidos, sopas de legumes, cenoura, abóbora, carne magra cozida na água / grelhada",
        "observacao": "sempre em pequenas quantidades."
      },
      "recomendacoes_importantes": {
        "adicionar_diariamente": ["Chia", "Linhaça", "Farelo de aveia"],
        "adocantes_opcoes": ["Sucralose (sachê ou pó)", "Stevia: Usar pouco."]
      },
      "alimentos_permitidos_recomendados": [
        "Raízes (principalmente inhame)",
        "Castanhas (em pequenas quantidades)",
        "Carnes magras, frango e peixe (assados no forno ou air fryer, grelhados na brasa ou cozidos na água)",
        "Farelo de aveia",
        "Maçã, abacate, frutas pouco doces (mínimo 3x/dia)",
        "Verduras e legumes (quiabo, cenoura, pepino, ervilha, sopas)",
        "Gelatina diet",
        "Ovo cozido",
        "Queijo ricota (até 2x/dia)",
        "Leite desnatado",
        "Muita água ao longo do dia"
      ],
      "atividade_fisica": {
        "instrucao_geral":
            "Evitar longos períodos sentado(a) com as pernas para baixo (prevenção de trombose).",
        "recomendacao_pratica":
            "Praticar atividades sem impacto, com progressão gradual até atingir 30 minutos/dia, 7 dias por semana:",
        "exemplos_atividades": [
          "Caminhada",
          "Pilates",
          "Treino aeróbico",
          "Bicicleta ergométrica",
          "Hidroginástica"
        ],
        "sugestao_video":
            "assistir ao vídeo no YouTube 'Combate à Obesidade - Cláudio Geriatra'."
      }
    },
    "recomendacoes_finais": {
      "itens": [
        "Controle do peso regularmente",
        "Disciplina diária",
        "Autoestima e autocuidado",
        "Cultivar fé e motivação"
      ],
      "sugestao_vida_longa_saudavel": {
        "titulo": "Sugestão para uma Vida Longa e Saudável",
        "mensagem":
            "Construir hábitos consistentes é mais importante do que buscar resultados rápidos. Pequenas mudanças mantidas ao longo do tempo transformam a saúde e o bem-estar."
      }
    },
    "contato": "Caso ainda tenha dúvidas, faça sua pergunta no APP Vida Longa!"
  },
  "ansiedade": {
    "empresa": {
      "nome": "Vida Longa",
      "slogan": "Viva mais. Viva melhor"
    },
    "receita_manipulacao_sugestao": {
      "instrucoes": "PARA MANIPULAÇÃO (SUGESTÃO para auxiliar no controle da ansiedade)",
      "detalhes": {
        "quantidade_capsulas": "30 a 90 cápsulas vegetais",
        "conservantes": "Sem conservantes",
        "uso": "Contínuo até obtenção dos resultados"
      },
      "componentes": [
        {
          "nome": "Valeriana",
          "dosagem": "100 mg"
        },
        {
          "nome": "Camomila",
          "dosagem": "100 mg"
        },
        {
          "nome": "L Triptofano",
          "dosagem": "50 mg"
        },
        {
          "nome": "Magnésio Quelato",
          "dosagem": "60 mg"
        },
        {
          "nome": "Hipérico",
          "dosagem": "100 mg"
        }
      ],
      "posologia": {
        "titulo": "POSOLOGIA",
        "instrucao": "Tomar 1 cápsula por via oral, uma vez ao dia, após as 20h."
      },
      "indicacoes": "Fórmula destinada a auxiliar:",
      "beneficios": [
        "Redução da ansiedade",
        "Melhora da concentração",
        "Melhora do humor",
        "Proteção da memória",
        "Redução do estresse"
      ]
    },
    "dicas_para_controle_ansiedade": {
      "titulo": "DICAS PARA CONTROLE DA ANSIEDADE",
      "recomendacao_geral": "Recomenda-se associar o uso da fórmula a hábitos saudáveis, como:",
      "itens": [
        "Prática de atividade física aeróbica: caminhada, dança, ciclismo e natação.",
        "Manutenção de rotina de sono.",
        "Técnicas de respiração e relaxamento.",
        "Redução do consumo de cafeína no período da tarde/noite."
      ]
    },
    "sugestao_vida_longa_saudavel": {
      "titulo": "SUGESTÃO PARA UMA VIDA LONGA E SAUDÁVEL",
      "dica": "Cuide do sono, da alimentação, da atividade física e do bem-estar emocional diariamente."
    },
    "contato": "Caso ainda tenha dúvidas, faça sua pergunta no APP Vida Longa!"
  },
  "ansiedade_insonia": {
    "empresa": {"nome": "Vida Longa", "slogan": "Viva mais. Viva melhor"},
    "receita_manipulacao_sugestao": {
      "instrucoes": "PARA MANIPULAÇÃO (SUGESTÃO)",
      "detalhes": {
        "quantidade_capsulas": "30 a 90 cápsulas vegetais",
        "conservantes": "Sem conservantes",
        "uso": "Contínuo até obtenção dos resultados"
      },
      "componentes": [
        {"nome": "Valeriana", "dosagem": "150 mg"},
        {"nome": "L Triptofano", "dosagem": "50 mg"},
        {"nome": "Camomila", "dosagem": "150 mg"},
        {"nome": "Hipérico", "dosagem": "100 mg"},
        {"nome": "Magnésio Quelato", "dosagem": "60 mg"},
        {"nome": "L Teanina", "dosagem": "60 mg"},
        {"nome": "Melatonina", "dosagem": "3 mg"}
      ],
      "posologia": {
        "titulo": "POSOLOGIA",
        "instrucao":
            "Tomar 1 cápsula por via oral, uma vez ao dia, meia hora antes de deitar."
      },
      "indicacoes": "Fórmula destinada a auxiliar:",
      "beneficios": [
        "Melhora da insônia e regularização do ciclo do sono",
        "Redução da ansiedade",
        "Diminuição da compulsão alimentar",
        "Melhora da concentração",
        "Estabilização do humor",
        "Redução de estresse",
        "Proteção da memória e suporte cognitivo",
        "Suporte ao metabolismo e controle de peso"
      ]
    },
    "orientacoes_gerais": {
      "titulo": "ORIENTAÇÕES GERAIS",
      "higiene_do_sono": {
        "titulo": "Higiene do Sono",
        "itens": [
          "Evitar telas 1 hora antes de dormir",
          "Manter ambiente escuro e silencioso",
          "Evitar refeições pesadas à noite",
          "Manter rotina de sono regular"
        ]
      },
      "controle_da_ansiedade": {
        "titulo": "Controle da Ansiedade",
        "itens": [
          "Atividade física aeróbica: caminhada, dança, natação, ciclismo",
          "Técnicas de respiração",
          "Evitar café após as 16h",
          "Evitar longos períodos sentado(a)",
          "Incluir fibras: chia, linhaça, farelo de aveia"
        ]
      },
      "orientacoes_controle_peso_bem_estar": {
        "titulo": "Orientações para controle de peso e bem-estar",
        "itens": [
          "Evitar açúcar, ultraprocessados, frituras, massas e excesso de sal",
          "Preferir alimentos leves à noite",
          "Aumentar consumo de verduras, proteínas magras e água",
          "Consumir frutas menos doces e raízes (inhame, batata doce)"
        ]
      }
    },
    "sugestao_vida_longa_saudavel": {
      "titulo": "SUGESTÃO PARA UMA VIDA LONGA E SAUDÁVEL",
      "dica":
          "Disciplina diária + sono de qualidade + boa alimentação + movimento = saúde duradoura e bem-estar contínuo."
    },
    "contato": "Caso ainda tenha dúvidas, faça sua pergunta no APP Vida Longa!"
  },
  "controlesono_ansiedade": {
    "empresa": {"nome": "Vida Longa", "slogan": "Viva mais Viva melhor"},
    "receita_manipulacao_sugestao": {
      "instrucoes": "PARA MANIPULAÇÃO (SUGESTÃO)",
      "detalhes": {
        "quantidade_capsulas": "30 a 90 cápsulas vegetais",
        "conservantes": "Sem conservantes",
        "uso": "Contínuo"
      },
      "componentes": [
        {"nome": "L-Triptofano", "dosagem": "100 mg"},
        {"nome": "Valeriana", "dosagem": "50 mg"},
        {"nome": "Camomila", "dosagem": "50 mg"},
        {"nome": "L Triptofano", "dosagem": "50 mg"},
        {"nome": "Hipérico", "dosagem": "50 mg"},
        {"nome": "Picolinato de Cromo", "dosagem": "150 mcg"},
        {"nome": "Vitamina D3", "dosagem": "1000 UI"},
        {"nome": "Magnésio Quelato", "dosagem": "30 mg"},
        {"nome": "Zinco Quelato", "dosagem": ""}
      ],
      "posologia": {
        "titulo": "POSOLOGIA",
        "instrucao":
            "Tomar 1 cápsula por via oral, duas vezes ao dia, após as 07h e após as 17h."
      },
      "indicacoes": "Fórmula destinada a auxiliar:",
      "beneficios": [
        "Redução da ansiedade",
        "Controle da compulsão alimentar",
        "Redução da vontade de doces",
        "Estabilização do humor",
        "Suporte ao metabolismo",
        "Apoio no emagrecimento saudável",
        "Melhora da concentração e foco"
      ]
    },
    "orientacoes_de_apoio_ao_tratamento": {
      "titulo": "ORIENTAÇÕES DE APOIO AO TRATAMENTO",
      "estrategias_controle_de_peso": {
        "titulo": "Estratégias de Controle de Peso",
        "evitar": [
          "Açúcar, doces e excesso de carboidratos refinados",
          "Frituras e ultraprocessados",
          "Café à noite",
          "Comer grandes quantidades no jantar",
          "Excesso de sal e alimentos gordurosos"
        ],
        "preferir": [
          "Alimentos leves no período da noite",
          "Proteínas magras (frango, peixe, ovos)",
          "Verduras, legumes, sopas",
          "Frutas menos doces (maçã, abacate)"
        ],
        "adicionar_diariamente": [
          "Fibras: chia, linhaça, farelo de aveia",
          "Ao menos 2 L de água por dia"
        ]
      },
      "estrategias_para_ansiedade": {
        "titulo": "Estratégias para Ansiedade",
        "itens": [
          "Caminhada, dança, natação ou qualquer exercício aeróbico",
          "Técnicas de respiração (4-4-6, por exemplo)",
          "Evitar longos períodos sentado(a)",
          "Dormir em horários regulares",
          "Reduzir cafeína após as 16h"
        ]
      }
    },
    "sugestao_vida_longa_saudavel": {
      "titulo": "SUGESTÃO PARA UMA VIDA LONGA E SAUDÁVEL",
      "dica":
          "Controle emocional + alimentação consciente + sono regulado + movimento diário = corpo e mente mais equilibrados."
    },
    "contato": "Caso ainda tenha dúvidas, faça sua pergunta no APP Vida Longa!"
  },
  "controlepeso_ansiedade_insonia": {
    "empresa": {"nome": "Vida Longa", "slogan": "Viva mais. Viva melhor"},
    "formulas_manipulacao": [
      {
        "titulo": "SUGESTÃO para auxiliar no controle de peso",
        "detalhes": {
          "quantidade_capsulas": "30 a 90 cápsulas vegetais",
          "conservantes": "Sem conservantes",
          "uso": "Contínuo até obtenção dos resultados"
        },
        "componentes": [
          {"nome": "L-Triptofano", "dosagem": "100 mg"},
          {"nome": "Picolinato de cromo", "dosagem": "150 mcg"},
          {"nome": "Camomila", "dosagem": "30 mg"},
          {"nome": "Vitamina D3", "dosagem": "1000 UI"},
          {"nome": "Zinco Quelato", "dosagem": "5 mg"}
        ],
        "posologia": {
          "instrucao":
              "Tomar 1 cápsula por via oral, duas vezes ao dia, após as 07h e após as 17h."
        }
      },
      {
        "titulo": "SUGESTÃO para auxiliar no sono e ansiedade",
        "detalhes": {
          "quantidade_capsulas": "30 a 90 cápsulas vegetais",
          "conservantes": "Sem conservantes",
          "uso": "Contínuo até obtenção dos resultados"
        },
        "componentes": [
          {"nome": "Valeriana", "dosagem": "150 mg"},
          {"nome": "Camomila", "dosagem": "150 mg"},
          {"nome": "Hipérico", "dosagem": "100 mg"},
          {"nome": "Magnésio Quelato", "dosagem": "60 mg"},
          {"nome": "L Teanina", "dosagem": "60 mg"},
          {"nome": "Melatonina", "dosagem": "3 mg"}
        ],
        "posologia": {
          "instrucao":
              "Tomar 1 cápsula por via oral, uma vez ao dia, meia hora antes de ir deitar."
        }
      }
    ],
    "indicacoes": {
      "titulo": "INDICAÇÕES",
      "beneficios": [
        "Redução da ansiedade e irritabilidade",
        "Melhora do sono e diminuição da insônia",
        "Controle da compulsão alimentar",
        "Redução da vontade de doces",
        "Estabilização do humor",
        "Suporte ao emagrecimento saudável",
        "Melhora da concentração e disposição",
        "Redução do estresse físico e mental"
      ]
    },
    "orientacoes_alimentares_e_de_rotina": {
      "titulo": "ORIENTAÇÕES ALIMENTARES E DE ROTINA",
      "para_controle_de_peso": {
        "titulo": "Para Controle de Peso",
        "evitar": [
          "Açúcar, doces, refrigerantes",
          "Carboidratos refinados (pão, bolo, biscoitos)",
          "Frituras (mesmo no azeite)",
          "Ultraprocessados",
          "Café à noite",
          "Jantar pesado"
        ],
        "preferir": [
          "Sopas leves no jantar",
          "Ovos, frango, peixe, legumes cozidos",
          "Verduras e legumes",
          "Frutas menos doces: maçã, abacate, melão"
        ],
        "adicionar_diariamente": [
          "Chia, linhaça ou farelo de aveia",
          "2 litros de água por dia"
        ]
      },
      "higiene_do_sono": {
        "titulo": "Higiene do Sono",
        "itens": [
          "Evitar telas 1 hora antes de dormir",
          "Evitar comer tarde",
          "Ambiente escuro e silencioso",
          "Evitar café após as 16h"
        ]
      },
      "reducao_da_ansiedade": {
        "titulo": "Redução da Ansiedade",
        "itens": [
          "Caminhada, dança, hidroginástica ou pedal",
          "Técnicas de respiração",
          "Evitar ficar muito tempo sentado(a)",
          "Evitar estimulantes à noite"
        ]
      }
    },
    "sugestao_vida_longa_saudavel": {
      "titulo": "SUGESTÃO PARA UMA VIDA LONGA E SAUDÁVEL",
      "dica":
          "Equilíbrio emocional + sono restaurador + alimentação leve + rotina de movimento = saúde e envelhecimento saudável."
    },
    "contato": "Caso ainda tenha dúvidas, faça sua pergunta no APP Vida Longa!"
  },
  "controlepeso_insonia": {
    "empresa": {"nome": "Vida Longa", "slogan": "Viva mais. Viva melhor"},
    "formulas_manipulacao": [
      {
        "titulo": "SUGESTÃO para auxiliar no controle de peso",
        "detalhes": {
          "quantidade_capsulas": "30 a 90 cápsulas vegetais",
          "conservantes": "Sem conservantes",
          "uso": "Contínuo até obtenção dos resultados"
        },
        "componentes": [
          {"nome": "L-Triptofano", "dosagem": "100 mg"},
          {"nome": "Picolinato de cromo", "dosagem": "150 mcg"},
          {"nome": "Camomila", "dosagem": "30 mg"},
          {"nome": "Vitamina D3", "dosagem": "1000 UI"},
          {"nome": "Zinco Quelato", "dosagem": "5 mg"}
        ],
        "posologia": {
          "instrucao":
              "Tomar 1 cápsula por via oral, duas vezes ao dia, após as 07h e após as 17h."
        }
      },
      {
        "titulo": "SUGESTÃO para auxiliar no sono",
        "detalhes": {
          "quantidade_capsulas": "30 a 90 cápsulas vegetais",
          "conservantes": "Sem conservantes",
          "uso": "Contínuo até obtenção dos resultados"
        },
        "componentes": [
          {"nome": "Valeriana", "dosagem": "100 mg"},
          {"nome": "Magnésio Quelato", "dosagem": "60 mg"},
          {"nome": "Camomila", "dosagem": "100 mg"},
          {"nome": "L Teanina", "dosagem": "60 mg"},
          {"nome": "Melatonina", "dosagem": "3 mg"}
        ],
        "posologia": {
          "instrucao":
              "Tomar 1 cápsula por via oral, uma vez ao dia, meia hora antes de deitar."
        }
      }
    ],
    "indicacoes_gerais": {
      "titulo": "INDICAÇÕES",
      "beneficios": [
        "Melhora da insônia (início e manutenção do sono)",
        "Redução da ansiedade noturna",
        "Diminuição da compulsão alimentar, especialmente à noite",
        "Controle de apetite durante o dia",
        "Estabilização do humor",
        "Melhora da concentração",
        "Suporte ao metabolismo",
        "Suporte ao emagrecimento",
        "Redução do estresse e regulação neuro-hormonal"
      ]
    },
    "orientacoes_complementares": {
      "titulo": "ORIENTAÇÕES COMPLEMENTARES",
      "higiene_do_sono": {
        "titulo": "Higiene do Sono",
        "itens": [
          "Evitar telas 1h antes de dormir",
          "Preferir quarto escuro e silencioso",
          "Evitar refeições pesadas no jantar",
          "Manter rotina regular de horário para dormir"
        ]
      },
      "estrategias_controle_de_peso": {
        "titulo": "Estratégias de Controle de Peso",
        "evitar": [
          "Açúcar, doces e massas",
          "Frituras (mesmo no azeite)",
          "Ultraprocessados",
          "Café à noite",
          "Excesso de sal",
          "Alimentação pesada após as 18h"
        ],
        "preferir_a_noite": [
          "Ovos cozidos",
          "Sopas de legumes",
          "Carne magra cozida",
          "Abóbora, cenoura, verduras",
          "Porções pequenas"
        ],
        "adicionar_diariamente": [
          "Chia, linhaça ou farelo de aveia",
          "2 a 3 frutas menos doces (maçã, abacate, mamão)",
          "Água em abundância"
        ]
      },
      "atividade_fisica": {
        "titulo": "Atividade Física",
        "instrucoes": [
          "Evitar longos períodos sentado(a)",
          "Caminhada, pilates, bicicleta ergométrica, hidroginástica",
          "Meta: 30 min/dia - 7 dias/semana"
        ]
      }
    },
    "sugestao_vida_longa_saudavel": {
      "titulo": "SUGESTÃO PARA UMA VIDA LONGA E SAUDÁVEL",
      "dica":
          "Sono reparador + alimentação consciente + movimento diário = metabolismo equilibrado, energia estável e envelhecimento saudável."
    },
    "contato": "Caso ainda tenha dúvidas, faça sua pergunta no APP Vida Longa!"
  }
    ,
    "controle_peso_ansiedade": {
      "empresa": {
        "nome": "Vida Longa",
        "slogan": "Viva mais Viva melhor"
      },
      "receita_manipulacao_sugestao": {
        "instrucoes": "PARA MANIPULAÇÃO (SUGESTÃO)",
        "detalhes": {
          "quantidade_capsulas": "30 a 90 cápsulas vegetais",
          "conservantes": "Sem conservantes",
          "uso": "Contínuo"
        },
        "componentes": [
          {"nome": "L-Triptofano", "dosagem": "100 mg"},
          {"nome": "Valeriana", "dosagem": "50 mg"},
          {"nome": "Camomila", "dosagem": "50 mg"},
          {"nome": "L Triptofano", "dosagem": "50 mg"},
          {"nome": "Hipérico", "dosagem": "50 mg"},
          {"nome": "Picolinato de Cromo", "dosagem": "150 mcg"},
          {"nome": "Vitamina D3", "dosagem": "1000 UI"},
          {"nome": "Magnésio Quelato", "dosagem": "30 mg"},
          {"nome": "Zinco Quelato", "dosagem": ""}
        ],
        "posologia": {
          "titulo": "POSOLOGIA",
          "instrucao": "Tomar 1 cápsula por via oral, duas vezes ao dia, após as 07h e após as 17h."
        },
        "indicacoes": "Fórmula destinada a auxiliar:",
        "beneficios": [
          "Redução da ansiedade",
          "Controle da compulsão alimentar",
          "Redução da vontade de doces",
          "Estabilização do humor",
          "Suporte ao metabolismo",
          "Apoio no emagrecimento saudável",
          "Melhora da concentração e foco"
        ]
      },
      "orientacoes_de_apoio_ao_tratamento": {
        "titulo": "ORIENTAÇÕES DE APOIO AO TRATAMENTO",
        "estrategias_controle_de_peso": {
          "titulo": "Estratégias de Controle de Peso",
          "evitar": [
            "Açúcar, doces e excesso de carboidratos refinados",
            "Frituras e ultraprocessados",
            "Café à noite",
            "Comer grandes quantidades no jantar",
            "Excesso de sal e alimentos gordurosos"
          ],
          "preferir": [
            "Alimentos leves no período da noite",
            "Proteínas magras (frango, peixe, ovos)",
            "Verduras, legumes, sopas",
            "Frutas menos doces (maçã, abacate)"
          ],
          "adicionar_diariamente": [
            "Fibras: chia, linhaça, farelo de aveia",
            "Ao menos 2 L de água por dia"
          ]
        },
        "estrategias_para_ansiedade": {
          "titulo": "Estratégias para Ansiedade",
          "itens": [
            "Caminhada, dança, natação ou qualquer exercício aeróbico",
            "Técnicas de respiração (4-4-6, por exemplo)",
            "Evitar longos períodos sentado(a)",
            "Dormir em horários regulares",
            "Reduzir cafeína após as 16h"
          ]
        }
      },
      "sugestao_vida_longa_saudavel": {
        "titulo": "SUGESTÃO PARA UMA VIDA LONGA E SAUDÁVEL",
        "dica": "Controle emocional + alimentação consciente + sono regulado + movimento diário = corpo e mente mais equilibrados."
      },
      "contato": "Caso ainda tenha dúvidas, faça sua pergunta no APP Vida Longa!"
    }
  };

  Future<void> _saveAndShareImage() async {
    if (_isLoading) return;
    setState(() => _isLoading = true);

    try {
      final Uint8List? image = await _screenshotController.capture(
        delay: const Duration(milliseconds: 300),
        pixelRatio: 3.0,
      );

      if (image == null) {
        _showErrorDialog("Erro ao capturar a tela");
        return;
      }

      // Verificar se tem permissão antes de tentar salvar
      final hasAccess = await Gal.hasAccess();
      
      if (!hasAccess) {
        // Solicitar permissão
        final granted = await Gal.requestAccess();
        
        if (!granted) {
          _showPermissionDeniedDialog();
          return;
        }
      }

      // Salvar imagem diretamente na galeria usando o pacote gal
      await Gal.putImageBytes(image, album: 'Vida Longa');

      // Mostrar sucesso
      _showSuccessDialog("Imagem salva com sucesso na galeria!");
    } catch (e) {
      _showErrorDialog("Erro ao salvar a imagem: ${e.toString()}");
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _showSuccessDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Sucesso"),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Erro"),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }

  void _showPermissionDeniedDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Permissão Negada"),
        content: const Text(
          "A permissão de armazenamento foi negada permanentemente. "
          "Para salvar imagens, você precisa habilitar a permissão nas configurações do aplicativo.",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancelar"),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              openAppSettings();
            },
            child: const Text("Abrir Configurações"),
          ),
        ],
      ),
    );
  }

  Widget _buildProtocolContent(Map<String, dynamic> protocolData) {
    final List<Widget> widgets = [];

    // Debug: mostrar chaves do protocolo para garantir que os dados chegaram
    // ignore: avoid_print
    print('Protocol keys: ${protocolData.keys.toList()}');

    // Receita de manipulação
    if (protocolData['receita_manipulacao_sugestao'] != null) {
      final receita = protocolData['receita_manipulacao_sugestao'];
      widgets.add(_buildSection("RECEITA PARA MANIPULAÇÃO", receita));
    }

    // Fórmulas de manipulação (lista de sugestões quando presente)
    if (protocolData['formulas_manipulacao'] is List) {
      final formulas = (protocolData['formulas_manipulacao'] as List)
          .cast<Map<String, dynamic>>();
      for (final formula in formulas) {
        widgets.add(_buildSection(formula['titulo'] ?? 'SUGESTÃO', formula));
      }
    }

    // Plano de cuidados
    if (protocolData['plano_de_cuidados_controle_peso'] != null) {
      final plano = protocolData['plano_de_cuidados_controle_peso'];
      widgets.add(_buildSection("PLANO DE CUIDADOS", plano));
    }

    // Orientações de higiene
    if (protocolData['orientacoes_higiene_sono'] != null) {
      final orientacoes = protocolData['orientacoes_higiene_sono'];
      widgets.add(_buildSection(
        orientacoes['titulo'] ?? 'ORIENTAÇÕES',
        orientacoes,
      ));
    }

    // Dicas para controle de ansiedade
    if (protocolData['dicas_para_controle_ansiedade'] != null) {
      final dicas = protocolData['dicas_para_controle_ansiedade'];
      widgets.add(_buildSection(
        dicas['titulo'] ?? 'DICAS',
        dicas,
      ));
    }

    // Orientações de apoio ao tratamento
    if (protocolData['orientacoes_de_apoio_ao_tratamento'] != null) {
      final orientacoes = protocolData['orientacoes_de_apoio_ao_tratamento'];
      widgets.add(_buildSection(
        orientacoes['titulo'] ?? 'ORIENTAÇÕES DE APOIO',
        orientacoes,
      ));
    }

    // Orientações gerais
    if (protocolData['orientacoes_gerais'] != null) {
      final orientacoes = protocolData['orientacoes_gerais'];
      widgets.add(_buildSection(
        orientacoes['titulo'] ?? 'ORIENTAÇÕES GERAIS',
        orientacoes,
      ));
    }

    // Orientações alimentares e de rotina
    if (protocolData['orientacoes_alimentares_e_de_rotina'] != null) {
      final orientacoes = protocolData['orientacoes_alimentares_e_de_rotina'];
      widgets.add(_buildSection(
        orientacoes['titulo'] ?? 'ORIENTAÇÕES ALIMENTARES',
        orientacoes,
      ));
    }

    // Orientações complementares
    if (protocolData['orientacoes_complementares'] != null) {
      final orientacoes = protocolData['orientacoes_complementares'];
      widgets.add(_buildSection(
        orientacoes['titulo'] ?? 'ORIENTAÇÕES COMPLEMENTARES',
        orientacoes,
      ));
    }

    // Indicações gerais (para protocolos como ansiedade_insonia)
    if (protocolData['indicacoes_gerais'] != null) {
      final indicacoesGerais = protocolData['indicacoes_gerais'];
      widgets.add(_buildSection("INDICAÇÕES", indicacoesGerais));
    }

    // Indicações (para protocolos como controlepeso_ansiedade_insonia)
    if (protocolData['indicacoes'] != null && protocolData['indicacoes'] is Map) {
      final indicacoes = protocolData['indicacoes'];
      widgets.add(_buildSection("INDICAÇÕES", indicacoes));
    }

    // Recomendações finais
    if (protocolData['recomendacoes_finais'] != null) {
      final recomendacoes = protocolData['recomendacoes_finais'];
      widgets.add(_buildSection("RECOMENDAÇÕES FINAIS", recomendacoes));
    }

    // Sugestão vida longa
    if (protocolData['sugestao_vida_longa_saudavel'] != null) {
      final sugestao = protocolData['sugestao_vida_longa_saudavel'];
      widgets.add(
        Container(
          padding: const EdgeInsets.all(16),
          margin: const EdgeInsets.only(bottom: 20),
          decoration: BoxDecoration(
            color: Colors.blue.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.blue.withOpacity(0.3)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DefaultText(
                sugestao['titulo'] ?? sugestao['dica'] ?? '',
                fontSize: 16,
                fontWeight: FontWeight.bold,
                maxLines: 2,
              ),
              if (sugestao['mensagem'] != null) ...[
                const SizedBox(height: 12),
                DefaultText(
                  sugestao['mensagem'],
                  fontSize: 14,
                ),
              ],
              if (sugestao['dica'] != null && sugestao['titulo'] != null) ...[
                const SizedBox(height: 12),
                DefaultText(
                  sugestao['dica'],
                  fontSize: 14,
                  maxLines: 5,
                ),
              ],
            ],
          ),
        ),
      );
    }

    // Contato
    if (protocolData['contato'] != null) {
      widgets.add(
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: DefaultText(
            protocolData['contato'],
            fontSize: 14,
            fontWeight: FontWeight.w500,
            textAlign: TextAlign.center,
            maxLines: 5,
          ),
        ),
      );
    }

    return Column(children: widgets);
  }

  Widget _buildSection(String title, Map<String, dynamic> data) {
    final List<Widget> children = [
      DefaultText(
        title,
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: AppColors.primary,
        maxLines: 5,
      ),
      const SizedBox(height: 16),
    ];

    // Instruções e detalhes gerais (quantidade de cápsulas, tipo, conservantes, uso)
    if (data['instrucoes'] != null) {
      children.add(
        Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: DefaultText(
            data['instrucoes'],
            fontSize: 14,
            maxLines: 5,
          ),
        ),
      );
    }

    final detalhes = data['detalhes'] is Map ? data['detalhes'] as Map<String, dynamic> : data;
    final List<Widget> meta = [];
    if (detalhes['quantidade_capsulas'] != null) {
      meta.add(RichText(
        text: TextSpan(
          style: const TextStyle(fontSize: 13, color: Colors.black87),
          children: [
            const TextSpan(text: 'Quantidade: ', style: TextStyle(fontWeight: FontWeight.bold)),
            TextSpan(text: '${detalhes['quantidade_capsulas']}'),
          ],
        ),
      ));
    }
    if (detalhes['tipo_capsula'] != null) {
      meta.add(RichText(
        text: TextSpan(
          style: const TextStyle(fontSize: 13, color: Colors.black87),
          children: [
            const TextSpan(text: 'Tipo de cápsula: ', style: TextStyle(fontWeight: FontWeight.bold)),
            TextSpan(text: '${detalhes['tipo_capsula']}'),
          ],
        ),
      ));
    }
    if (detalhes['conservantes'] != null) {
      meta.add(RichText(
        text: TextSpan(
          style: const TextStyle(fontSize: 13, color: Colors.black87),
          children: [
            const TextSpan(text: 'Conservantes: ', style: TextStyle(fontWeight: FontWeight.bold)),
            TextSpan(text: '${detalhes['conservantes']}'),
          ],
        ),
      ));
    }
    if (detalhes['uso'] != null) {
      meta.add(RichText(
        text: TextSpan(
          style: const TextStyle(fontSize: 13, color: Colors.black87),
          children: [
            const TextSpan(text: 'Uso: ', style: TextStyle(fontWeight: FontWeight.bold)),
            TextSpan(text: '${detalhes['uso']}'),
          ],
        ),
      ));
    }
    if (detalhes['tratamento'] != null) {
      meta.add(RichText(
        text: TextSpan(
          style: const TextStyle(fontSize: 13, color: Colors.black87),
          children: [
            const TextSpan(text: 'Tratamento: ', style: TextStyle(fontWeight: FontWeight.bold)),
            TextSpan(text: '${detalhes['tratamento']}'),
          ],
        ),
      ));
    }
    if (meta.isNotEmpty) {
      children.add(
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            ...meta.map((w) => Padding(padding: const EdgeInsets.only(bottom: 4), child: w)),
            const SizedBox(height: 8),
          ],
        ),
      );
    }

    // Componentes
    if (data['componentes'] is List) {
      children.add(
        Container(
          margin: const EdgeInsets.symmetric(vertical: 12),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Colors.grey.shade50,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: Column(
            children: [
              Row(
                children: const [
                  Expanded(
                    child:
                        DefaultText("Medicamento", fontWeight: FontWeight.bold),
                  ),
                  DefaultText("Dosagem", fontWeight: FontWeight.bold),
                ],
              ),
              const Divider(),
              ...((data['componentes'] as List).cast<Map<String, dynamic>>()).map(
                (comp) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Row(
                    children: [
                      Expanded(
                        child: DefaultText(comp['nome'] ?? ''),
                      ),
                      DefaultText(comp['dosagem'] ?? '', maxLines: 5),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    // Posologia
    if (data['posologia'] != null) {
      final posologia = data['posologia'];
      children.add(
        Container(
          margin: const EdgeInsets.symmetric(vertical: 12),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Colors.orange.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DefaultText(
                "POSOLOGIA",
                fontWeight: FontWeight.bold,
                fontSize: 16,
                maxLines: 5,
              ),
              const SizedBox(height: 12),
              DefaultText(
                posologia['instrucao'] ?? posologia['titulo'] ?? '',
                fontSize: 14,
                maxLines: 3,
              ),
              if (posologia['observacao'] != null) ...[
                const SizedBox(height: 8),
                DefaultText(
                  "• ${posologia['observacao']}",
                  fontSize: 13,
                  maxLines: 3,
                  color: Colors.grey[700],
                ),
              ],
            ],
          ),
        ),
      );
    }

    // Indicações e Benefícios
    if (data['indicacoes'] != null || data['indicacao'] != null || data['beneficios'] != null) {
      final indicacoesObj = data['indicacoes'] is Map ? data['indicacoes'] as Map<String, dynamic> : null;
      final beneficios = indicacoesObj != null ? indicacoesObj['beneficios'] : data['beneficios'];
      
      if (data['indicacoes'] != null || data['indicacao'] != null || beneficios != null) {
        final List<Widget> indicacoesChildren = [];
        
        if (data['indicacoes'] is String) {
          indicacoesChildren.add(DefaultText(
            data['indicacoes'],
            fontWeight: FontWeight.bold,
            fontSize: 14,
            maxLines: 5,
          ));
        }
        
        if (indicacoesObj != null && indicacoesObj['titulo'] != null) {
          indicacoesChildren.add(DefaultText(
            indicacoesObj['titulo'],
            fontWeight: FontWeight.bold,
            fontSize: 14,
            maxLines: 5,
          ));
        }
        
        if (data['indicacao'] != null) {
          indicacoesChildren.add(DefaultText(
            data['indicacao'],
            fontWeight: FontWeight.bold,
            fontSize: 14,
            maxLines: 5,
          ));
        }
        
        if (beneficios is List && beneficios.isNotEmpty) {
          if (indicacoesChildren.isNotEmpty) {
            indicacoesChildren.add(const SizedBox(height: 8));
          }
          indicacoesChildren.addAll(
            beneficios.map(
              (beneficio) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const DefaultText("• ", fontWeight: FontWeight.bold),
                    Expanded(
                      child: DefaultText(
                        beneficio.toString(),
                        fontSize: 14,
                        maxLines: 5,
                      ),
                    ),
                  ],
                ),
              ),
            ).toList()
          );
        }
        
        if (indicacoesChildren.isNotEmpty) {
          children.add(
            Container(
              margin: const EdgeInsets.symmetric(vertical: 12),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.green.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: indicacoesChildren,
              ),
            ),
          );
        }
      }
    }

    // Orientações
    if (data['orientacoes'] is List) {
      children.add(
        Container(
          margin: const EdgeInsets.symmetric(vertical: 12),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Colors.blue.withOpacity(0.05),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: (data['orientacoes'] as List).map(
              (orientacao) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const DefaultText("• ", fontWeight: FontWeight.bold),
                    Expanded(
                      child: DefaultText(
                        orientacao.toString(),
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
            ).toList(),
          ),
        ),
      );
    }

    // Recomendação geral (para dicas)
    if (data['recomendacao_geral'] != null) {
      children.add(
        Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: DefaultText(
            data['recomendacao_geral'],
            fontSize: 14,
            maxLines: 5,
          ),
        ),
      );
    }

    // Itens (para planos de cuidados)
    if (data['itens'] is List) {
      children.add(
        Container(
          margin: const EdgeInsets.symmetric(vertical: 12),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Colors.purple.withOpacity(0.05),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: (data['itens'] as List).map(
              (item) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const DefaultText("• ", fontWeight: FontWeight.bold),
                    Expanded(
                      child: DefaultText(
                        item.toString(),
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
            ).toList(),
          ),
        ),
      );
    }

    // Motivos para evitar óleos e frituras (texto descritivo)
    if (data['motivos_para_evitar_oleos_e_frituras'] != null) {
      children.add(
        Container(
          margin: const EdgeInsets.symmetric(vertical: 12),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Colors.red.withOpacity(0.05),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DefaultText(
                "Motivos para evitar óleos e frituras",
                fontWeight: FontWeight.bold,
                fontSize: 14,
                maxLines: 5,
              ),
              const SizedBox(height: 8),
              DefaultText(
                data['motivos_para_evitar_oleos_e_frituras'],
                fontSize: 13,
                maxLines: 5,
              ),
            ],
          ),
        ),
      );
    }

    // Evitar, Preferir e outros objetos com itens aninhados
    ['evitar', 'preferir', 'preferencias_noturnas'].forEach((key) {
      if (data[key] != null) {
        final section = data[key];
        if (section is Map) {
          final sectionTitle = section['titulo'] ?? key.replaceAll('_', ' ').toUpperCase();
          final sectionItems = section['itens'];
          final sectionObservacao = section['observacao'];
          
          if (sectionItems is List || sectionItems is String) {
            children.add(
              Container(
                margin: const EdgeInsets.symmetric(vertical: 12),
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.amber.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    DefaultText(
                      sectionTitle,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      maxLines: 5,
                    ),
                    const SizedBox(height: 8),
                    if (sectionItems is List)
                      ...sectionItems.map(
                        (item) => Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const DefaultText("• ", fontWeight: FontWeight.bold),
                              Expanded(
                                child: DefaultText(
                                  item.toString(),
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    if (sectionItems is String)
                      DefaultText(
                        sectionItems,
                        fontSize: 13,
                        maxLines: 5,
                      ),
                    if (sectionObservacao != null) ...[
                      const SizedBox(height: 8),
                      DefaultText(
                        "Observação: $sectionObservacao",
                        fontSize: 12,
                        maxLines: 5,
                        color: Colors.grey[700],
                      ),
                    ],
                  ],
                ),
              ),
            );
          }
        }
      }
    });

    // Alimentos permitidos recomendados (lista direta)
    if (data['alimentos_permitidos_recomendados'] is List) {
      children.add(
        Container(
          margin: const EdgeInsets.symmetric(vertical: 12),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Colors.deepOrange.withOpacity(0.05),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DefaultText(
                "ALIMENTOS PERMITIDOS E RECOMENDADOS",
                fontWeight: FontWeight.bold,
                fontSize: 14,
                maxLines: 5,
              ),
              const SizedBox(height: 8),
              ...(data['alimentos_permitidos_recomendados'] as List).map(
                (item) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const DefaultText("• ", fontWeight: FontWeight.bold),
                      Expanded(
                        child: DefaultText(
                          item.toString(),
                          fontSize: 13,
                          maxLines: 5,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    // Recomendações importantes (adicionar_diariamente, adocantes_opcoes, etc)
    if (data['recomendacoes_importantes'] is Map) {
      final recomendacoes = data['recomendacoes_importantes'] as Map<String, dynamic>;
      recomendacoes.forEach((subKey, subValue) {
        if (subValue is List) {
          children.add(
            Container(
              margin: const EdgeInsets.symmetric(vertical: 12),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.teal.withOpacity(0.05),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  DefaultText(
                    subKey.replaceAll('_', ' ').toUpperCase(),
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    maxLines: 5,
                  ),
                  const SizedBox(height: 8),
                  ...subValue.map(
                    (item) => Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const DefaultText("• ", fontWeight: FontWeight.bold),
                          Expanded(
                            child: DefaultText(
                              item.toString(),
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }
      });
    }

    // Atividade física (pode estar em nível top ou aninhada)
    if (data['atividade_fisica'] is Map) {
      final atividade = data['atividade_fisica'] as Map<String, dynamic>;
      final List<Widget> atividadeChildren = [];
      
      if (atividade['instrucao_geral'] != null) {
        atividadeChildren.add(DefaultText(
          atividade['instrucao_geral'],
          fontSize: 13,
          maxLines: 5,
        ));
        atividadeChildren.add(const SizedBox(height: 8));
      }
      
      if (atividade['recomendacao_pratica'] != null) {
        atividadeChildren.add(DefaultText(
          atividade['recomendacao_pratica'],
          fontWeight: FontWeight.bold,
          fontSize: 13,
          maxLines: 5,
        ));
        atividadeChildren.add(const SizedBox(height: 8));
      }
      
      if (atividade['exemplos_atividades'] is List) {
        atividadeChildren.addAll(
          (atividade['exemplos_atividades'] as List).map(
            (item) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const DefaultText("• ", fontWeight: FontWeight.bold),
                  Expanded(
                    child: DefaultText(
                      item.toString(),
                      fontSize: 13,
                      maxLines: 5,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }
      
      if (atividade['instrucoes'] is List) {
        atividadeChildren.addAll(
          (atividade['instrucoes'] as List).map(
            (item) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const DefaultText("• ", fontWeight: FontWeight.bold),
                  Expanded(
                    child: DefaultText(
                      item.toString(),
                      fontSize: 13,
                      maxLines: 5,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }
      
      if (atividade['sugestao_video'] != null) {
        atividadeChildren.add(const SizedBox(height: 8));
        atividadeChildren.add(DefaultText(
          atividade['sugestao_video'],
          fontSize: 12,
          maxLines: 5,
          color: Colors.grey[700],
        ));
      }
      
      if (atividadeChildren.isNotEmpty) {
        children.add(
          Container(
            margin: const EdgeInsets.symmetric(vertical: 12),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.lightGreen.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DefaultText(
                  "ATIVIDADE FÍSICA",
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  maxLines: 5,
                ),
                const SizedBox(height: 8),
                ...atividadeChildren,
              ],
            ),
          ),
        );
      }
    }

    // Estratégias (controle de peso, ansiedade, etc)
    ['estrategias_controle_de_peso', 'estrategias_para_ansiedade', 'para_controle_de_peso', 'higiene_do_sono', 'estrategias_controle_de_peso', 'reducao_da_ansiedade', 'controle_da_ansiedade', 'orientacoes_controle_peso_bem_estar'].forEach((key) {
      if (data[key] is Map) {
        final estrategia = data[key] as Map<String, dynamic>;
        children.add(
          Container(
            margin: const EdgeInsets.symmetric(vertical: 12),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.cyan.withOpacity(0.05),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DefaultText(
                  estrategia['titulo'] ?? key.replaceAll('_', ' ').toUpperCase(),
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  maxLines: 5,
                ),
                const SizedBox(height: 8),
                if (estrategia['evitar'] is List)
                  ...[
                    DefaultText(
                      "Evitar:",
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                      maxLines: 5,
                    ),
                    ...(estrategia['evitar'] as List).map(
                      (item) => Padding(
                        padding: const EdgeInsets.only(bottom: 4, top: 4),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const DefaultText("• ", fontWeight: FontWeight.bold),
                            Expanded(
                              child: DefaultText(
                                item.toString(),
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                  ],
                if (estrategia['preferir'] is List)
                  ...[
                    DefaultText(
                      "Preferir:",
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                      maxLines: 5,
                    ),
                    ...(estrategia['preferir'] as List).map(
                      (item) => Padding(
                        padding: const EdgeInsets.only(bottom: 4, top: 4),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const DefaultText("• ", fontWeight: FontWeight.bold),
                            Expanded(
                              child: DefaultText(
                                item.toString(),
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                  ],
                if (estrategia['adicionar_diariamente'] is List)
                  ...[
                    DefaultText(
                      "Adicionar diariamente:",
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                      maxLines: 5,
                    ),
                    ...(estrategia['adicionar_diariamente'] as List).map(
                      (item) => Padding(
                        padding: const EdgeInsets.only(bottom: 4, top: 4),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const DefaultText("• ", fontWeight: FontWeight.bold),
                            Expanded(
                              child: DefaultText(
                                item.toString(),
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                if (estrategia['itens'] is List)
                  ...(estrategia['itens'] as List).map(
                    (item) => Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const DefaultText("• ", fontWeight: FontWeight.bold),
                          Expanded(
                            child: DefaultText(
                              item.toString(),
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                if (estrategia['preferir_a_noite'] is List)
                  ...[
                    DefaultText(
                      "Preferir à noite:",
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                      maxLines: 5,
                    ),
                    ...(estrategia['preferir_a_noite'] as List).map(
                      (item) => Padding(
                        padding: const EdgeInsets.only(bottom: 4, top: 4),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const DefaultText("• ", fontWeight: FontWeight.bold),
                            Expanded(
                              child: DefaultText(
                                item.toString(),
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
              ],
            ),
          ),
        );
      }
    });

    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: children,
      ),
    );
  }

  // TODO mudar aqui para o que era antes de dowloas na cetinha em laranja e baixar a imagem pra galeria
  @override
  Widget build(BuildContext context) {
    final List<String> selected =
        ModalRoute.of(context)!.settings.arguments as List<String>;

    print('Selected: $selected');

    final protocoloKey = _getProtocoloKey(selected);
    final protocolData =
        protocolosVidaLonga[protocoloKey] as Map<String, dynamic>?;

    return CustomAppScaffold(
      appBar: const DefaultAppBar(title: "Orientações", isWithBackButton: true),
      body: Stack(
        children: [
          Screenshot(
            controller: _screenshotController,
            child: Container(
              color: Colors.white,
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
                child: protocolData != null
                    ? _buildProtocolContent(protocolData)
                    : const Center(
                        child: DefaultText("Protocolo não encontrado"),
                      ),
              ),
            ),
          ),
          Positioned(
            bottom: 40,
            right: 20,
            child: GestureDetector(
              onTap: _isLoading ? null : _saveAndShareImage,
              child: Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: const LinearGradient(
                    colors: [Color(0xFFFF9800), Color(0xFFF57C00)],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.orange.withOpacity(0.3),
                      blurRadius: 12,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Center(
                  child: _isLoading
                      ? const SizedBox(
                          height: 22,
                          width: 22,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.5,
                            color: Colors.white,
                          ),
                        )
                      : const Icon(
                          Icons.download,
                          color: Colors.white,
                          size: 28,
                          ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
