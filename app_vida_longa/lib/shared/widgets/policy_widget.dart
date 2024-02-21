import 'package:app_vida_longa/domain/contants/app_colors.dart';
import 'package:app_vida_longa/shared/widgets/flat_button.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PolicyWidget extends StatelessWidget {
  const PolicyWidget({super.key});

  final double sectionSize = 24.0;
  final double paragraphSize = 16.0;

  TextStyle getDefaultFont(
      {FontWeight? fontWeight, double? fontSize, Color? color}) {
    return GoogleFonts.getFont(
      'Urbanist',
      color: AppColors.dimGray,
      fontWeight: FontWeight.w500,
      fontSize: 22.0,
    ).copyWith(
      fontWeight: fontWeight,
      fontSize: fontSize,
      color: color ?? AppColors.blackCard,
      overflow: TextOverflow.ellipsis,
    );
  }

  @override
  Widget build(BuildContext context) {
    List<SelectableText> listText = [
      SelectableText.rich(
        TextSpan(
          text: 'Política de Privacidade',
          style: getDefaultFont(
            fontSize: sectionSize,
          ),
        ),
      ),
      SelectableText.rich(
        TextSpan(
          text:
              'A sua privacidade é importante para nós. É política do Vida Longa respeitar a sua privacidade em relação a qualquer informação sua que possamos coletar no site Vida Longa, e outros sites que possuímos e operamos.',
          style: getDefaultFont(
            fontSize: paragraphSize,
          ),
        ),
      ),
      SelectableText.rich(
        TextSpan(
          text: 'Coleta de Imagem e Vídeo',
          style: getDefaultFont(
            fontSize: paragraphSize,
          ),
        ),
      ),
      SelectableText.rich(
        TextSpan(
          text:
              'Coleta de Imagem e Vídeo: Poderemos coletar e armazenar imagens e vídeos que você opte por compartilhar ou enviar através do aplicativo. Isso pode incluir fotos e vídeos capturados pela câmera do dispositivo ou imagens carregadas da galeria do dispositivo.',
          style: getDefaultFont(
            fontSize: paragraphSize,
          ),
        ),
      ),
      SelectableText.rich(
        TextSpan(
          text:
              'Acesso à Câmera e à Galeria: Para permitir a funcionalidade de coleta de imagem e vídeo, solicitaremos permissão para acessar a câmera e a galeria do seu dispositivo. Essas permissões são necessárias para capturar imagens em tempo real ou carregar imagens e vídeos existentes.',
          style: getDefaultFont(
            fontSize: paragraphSize,
          ),
        ),
      ),
      SelectableText.rich(
        TextSpan(
          text:
              'Apenas retemos as informações coletadas pelo tempo necessário para fornecer o serviço solicitado. Quando armazenamos dados, protegemos dentro de meios comercialmente aceitáveis para evitar perdas e roubos, bem como acesso, divulgação, cópia, uso ou modificação não autorizados.',
          style: getDefaultFont(
            fontSize: paragraphSize,
          ),
        ),
      ),
      SelectableText.rich(
        TextSpan(
          text:
              'Não compartilhamos informações de identificação pessoal publicamente ou com terceiros, exceto quando exigido por lei.',
          style: getDefaultFont(
            fontSize: paragraphSize,
          ),
        ),
      ),
      SelectableText.rich(
        TextSpan(
          text:
              'O nosso site pode ter links para sites externos que não são operados por nós. Esteja ciente de que não temos controle sobre o conteúdo e práticas desses sites e não podemos aceitar responsabilidade por suas respectivas políticas de privacidade.',
          style: getDefaultFont(
            fontSize: paragraphSize,
          ),
        ),
      ),
      SelectableText.rich(
        TextSpan(
          text:
              'Você é livre para recusar a nossa solicitação de informações pessoais, entendendo que talvez não possamos fornecer alguns dos serviços desejados. O uso continuado de nosso site será considerado como aceitação de nossas práticas em torno de privacidade e informações pessoais. Se você tiver alguma dúvida sobre como lidamos com dados do usuário e informações pessoais, entre em contacto conosco.',
          style: getDefaultFont(
            fontSize: paragraphSize,
          ),
        ),
      ),
      SelectableText.rich(
        TextSpan(
          text:
              '• O serviço Google AdSense que usamos para veicular publicidade usa um cookie DoubleClick para veicular anúncios mais relevantes em toda a Web e limitar o número de vezes que um determinado anúncio é exibido para você.',
          style: getDefaultFont(
            fontSize: paragraphSize,
          ),
        ),
      ),
      SelectableText.rich(
        TextSpan(
          text:
              '• Para mais informações sobre o Google AdSense, consulte as FAQs oficiais sobre privacidade do Google AdSense.',
          style: getDefaultFont(
            fontSize: paragraphSize,
          ),
        ),
      ),
      SelectableText.rich(
        TextSpan(
          text:
              '• Utilizamos anúncios para compensar os custos de funcionamento deste site e fornecer financiamento para futuros desenvolvimentos. Os cookies de publicidade comportamental usados por este site foram projetados para garantir que você forneça os anúncios mais relevantes sempre que possível, rastreando anonimamente seus interesses e apresentando coisas semelhantes que possam ser do seu interesse.',
          style: getDefaultFont(
            fontSize: paragraphSize,
          ),
        ),
      ),
      SelectableText.rich(
        TextSpan(
          text:
              '• Vários parceiros anunciam em nosso nome e os cookies de rastreamento de afiliados simplesmente nos permitem ver se nossos clientes acessaram o site através de um dos sites de nossos parceiros, para que possamos creditá-los adequadamente e, quando aplicável, permitir que nossos parceiros afiliados ofereçam qualquer promoção que pode fornecê-lo para fazer uma compra.',
          style: getDefaultFont(
            fontSize: paragraphSize,
          ),
        ),
      ),
      SelectableText.rich(
        TextSpan(
          text: 'Compromisso do Usuário',
          style: getDefaultFont(
            fontSize: sectionSize,
          ),
        ),
      ),
      SelectableText.rich(
        TextSpan(
          text:
              'O usuário se compromete a fazer uso adequado dos conteúdos e da informação que o Vida Longa oferece no site e com caráter enunciativo, mas não limitativo:',
          style: getDefaultFont(
            fontSize: paragraphSize,
          ),
        ),
      ),
      SelectableText.rich(
        TextSpan(
          text:
              'A) Não se envolver em atividades que sejam ilegais ou contrárias à boa fé a à ordem pública;',
          style: getDefaultFont(
            fontSize: paragraphSize,
          ),
        ),
      ),
      SelectableText.rich(
        TextSpan(
          text: 'B) Não difundir propaganda ou conteúdo de natureza racista;',
          style: getDefaultFont(
            fontSize: paragraphSize,
          ),
        ),
      ),
      SelectableText.rich(
        TextSpan(
          text:
              'C) Não causar danos aos sistemas físicos (hardwares) e lógicos (softwares) do Vida Longa, de seus fornecedores ou terceiros, para introduzir ou disseminar vírus informáticos ou quaisquer outros sistemas de hardware ou software que sejam capazes de causar danos anteriormente mencionados.',
          style: getDefaultFont(
            fontSize: paragraphSize,
          ),
        ),
      ),
      SelectableText.rich(
        TextSpan(
          text: 'Mais informações',
          style: getDefaultFont(
            fontSize: sectionSize,
          ),
        ),
      ),
      SelectableText.rich(
        TextSpan(
          text:
              'Esperemos que esteja esclarecido e, como mencionado anteriormente, se houver algo que você não tem certeza se precisa ou não, geralmente é mais seguro deixar os cookies ativados, caso interaja com um dos recursos que você usa em nosso site.',
          style: getDefaultFont(
            fontSize: paragraphSize,
          ),
        ),
      ),
      SelectableText.rich(
        TextSpan(
          text:
              'Se você tiver alguma dúvida sobre esta Política de Privacidade, entre em contato conosco em através do e-mail contato@vidalongaapp.com.',
          style: getDefaultFont(
            fontSize: paragraphSize,
          ),
        ),
      ),
      SelectableText.rich(
        TextSpan(
          text:
              'Esta política é efetiva a partir de 13 de Fevereiro de 2023, 17h21.',
          style: getDefaultFont(
            fontSize: paragraphSize,
          ),
        ),
      ),
      //
    ];

    return StatefulBuilder(
        builder: (BuildContext context, StateSetter setStateLocal) {
      return AlertDialog(
        backgroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
        contentPadding: const EdgeInsets.all(2),
        insetPadding: const EdgeInsets.all(2),
        content: Container(
          decoration: BoxDecoration(
            color: AppColors.backgroundColor,
            borderRadius: BorderRadius.circular(20),
          ),
          margin: const EdgeInsets.all(5),
          height: 800,
          width: double.maxFinite,
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.backgroundColor,
              borderRadius: BorderRadius.circular(20),
            ),
            margin: const EdgeInsets.all(20),
            child: Column(
              children: [
                Expanded(
                  child: SizedBox(
                    height: double.maxFinite,
                    child: ListView.builder(
                      itemCount: listText.length,
                      itemBuilder: (_, index) => Padding(
                        padding: const EdgeInsets.only(
                          top: 10,
                        ),
                        child: listText[index],
                      ),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.center,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 80,
                      vertical: 10,
                    ),
                    child: FlatButton(
                      textLabel: "Fechar",
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}
