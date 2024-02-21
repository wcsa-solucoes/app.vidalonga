import 'package:app_vida_longa/domain/contants/app_colors.dart';
import 'package:app_vida_longa/shared/widgets/flat_button.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TermsWiget extends StatelessWidget {
  const TermsWiget({super.key});

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
    List<Widget> listText = [
      SelectableText.rich(
        TextSpan(
          text: 'Termos e Condições Gerais',
          style: getDefaultFont(
            fontWeight: FontWeight.bold,
            fontSize: sectionSize,
          ),
        ),
      ),
      const SizedBox.shrink(),
      SelectableText.rich(
        TextSpan(
          text: 'Termos e Condições',
          style: getDefaultFont(
            fontSize: sectionSize,
          ),
        ),
      ),
      const SizedBox.shrink(),

      SelectableText.rich(
        TextSpan(
          text: 'Artigo 1 - Âmbito geral e objeto do acordo',
          style: getDefaultFont(
            fontWeight: FontWeight.bold,
            fontSize: sectionSize,
          ),
        ),
      ),
      SelectableText.rich(
        TextSpan(
          text:
              'Os seguintes termos e condições regem a relação entre você como cliente e nossa empresa enquanto interage através de nosso site https://vidalonga2.goodbarber.app e/ou em nosso aplicativo Vida Longa.',
          style: getDefaultFont(
            fontSize: paragraphSize,
          ),
        ),
      ),
      SelectableText.rich(
        TextSpan(
          text:
              'Navegar e/ou interagir em nosso site e/ou aplicativo significa que você concorda expressamente com estes termos sem reservas ou objeções.',
          style: getDefaultFont(
            fontSize: paragraphSize,
          ),
        ),
      ),
      SelectableText.rich(
        TextSpan(
          text:
              'Nossa empresa tem o direito de modificar ou adaptar estes termos a qualquer momento e sem aviso prévio. Estes termos são diretamente aplicáveis assim que forem publicados em nosso site e/ou aplicativo e/ou enviados a você por qualquer meio.',
          style: getDefaultFont(
            fontSize: paragraphSize,
          ),
        ),
      ),
      SelectableText.rich(
        TextSpan(
          text:
              'Por favor, leia estes Termos e Condições cuidadosamente antes de usar, interagir ou acessar nosso site e/ou aplicativo.',
          style: getDefaultFont(
            fontSize: paragraphSize,
          ),
        ),
      ),
      SelectableText.rich(
        TextSpan(
          text:
              'Ao concordar com estes termos, você nos garante que atingiu pelo menos a maioridade legal em seu país, estado ou província de residência. Se você é menor de idade, você nos concede todos os direitos e consentimento de seus representantes legais para usar nossos serviços. Se você não atingiu a maioridade legal, não deve usar nossos serviços.',
          style: getDefaultFont(
            fontSize: paragraphSize,
          ),
        ),
      ),
      SelectableText.rich(
        TextSpan(
          text:
              'Você não tem o direito de usar nossos serviços, site e/ou aplicativo para fins ilegais ou não autorizados.',
          style: getDefaultFont(
            fontSize: paragraphSize,
          ),
        ),
      ),
      SelectableText.rich(
        TextSpan(
          text:
              'Você não deve tentar hackear, alterar o uso ou as funções de nossos serviços, enviar vírus ou liderar ou tentar liderar qualquer outro tipo de ataque aos nossos serviços. Você também não deve tentar atentar contra a integridade de nossos serviços.',
          style: getDefaultFont(
            fontSize: paragraphSize,
          ),
        ),
      ),
      SelectableText.rich(
        TextSpan(
          text: 'Artigo 2 - Conteúdo e propriedade intelectual',
          style: getDefaultFont(
            fontSize: sectionSize,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      SelectableText.rich(
        TextSpan(
          text:
              'O conteúdo fornecido em nossos serviços pode ser acessado gratuitamente ou não. Alguns conteúdos podem exigir login ou uma assinatura paga válida (IAP, conteúdos ou seções restritas).',
          style: getDefaultFont(
            fontSize: paragraphSize,
          ),
        ),
      ),
      SelectableText.rich(
        TextSpan(
          text:
              'Se algum conteúdo exigir que você tenha uma conta ou seja registrado, consulte o Artigo 4 (Processo de registro) para saber como acessar nossos serviços.',
          style: getDefaultFont(
            fontSize: paragraphSize,
          ),
        ),
      ),
      SelectableText.rich(
        TextSpan(
          text:
              'O conteúdo dos nossos serviços destina-se a uso pessoal e não comercial. Todos os materiais disponíveis em nossos serviços são protegidos por direitos autorais e/ou direitos de propriedade intelectual.',
          style: getDefaultFont(
            fontSize: paragraphSize,
          ),
        ),
      ),
      SelectableText.rich(
        TextSpan(
          text:
              'Além disso, alguns conteúdos podem estar protegidos por outros direitos, como marcas registradas, patentes, segredos comerciais, direitos de banco de dados, direitos sui generis e outros direitos intelectuais ou de propriedade.',
          style: getDefaultFont(
            fontSize: paragraphSize,
          ),
        ),
      ),
      SelectableText.rich(
        TextSpan(
          text:
              'O usuário de nossos serviços não tem permissão para reproduzir total ou parcialmente qualquer conteúdo disponibilizado por meio de nossos serviços. O usuário também não reproduzirá nenhum de nossos logotipos, nomes, identidades visuais etc., tampouco tentará reproduzir, copiar ou produzir mera cópia de nossos serviços.',
          style: getDefaultFont(
            fontSize: paragraphSize,
          ),
        ),
      ),
      SelectableText.rich(
        TextSpan(
          text:
              'O usuário não modificará, copiará, colará, traduzirá, venderá, explorará ou transmitirá gratuitamente ou não qualquer conteúdo, texto, foto, imagem, desenho, conteúdo de áudio, podcast ou qualquer conteúdo disponível em nossos serviços.',
          style: getDefaultFont(
            fontSize: paragraphSize,
          ),
        ),
      ),
      SelectableText.rich(
        TextSpan(
          text:
              'Artigo 3 - Subscrição e pagamento (duração, pagamento recorrente, renovação automática)',
          style: getDefaultFont(
            fontSize: sectionSize,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      SelectableText.rich(
        TextSpan(
          text: 'Preço',
          style: getDefaultFont(
            fontSize: paragraphSize,
          ),
        ),
      ),
      SelectableText.rich(
        TextSpan(
          text:
              """As taxas de assinatura aplicáveis são mostradas antes de concluir o processo de pedido. Verifique como a Apple Store e a Google Store lidam com o gerenciamento de impostos e preços. Quaisquer alterações no impostos serão diretamente aplicáveis aos benefícios.""",
          style: getDefaultFont(
            fontSize: paragraphSize,
          ),
        ),
      ),
      SelectableText.rich(
        TextSpan(
          text:
              'Em relação a alterações ou modificações de taxas, nossa empresa se reserva o direito de alterar qualquer taxa ou tarifa a qualquer momento e sem aviso prévio.',
          style: getDefaultFont(
            fontSize: paragraphSize,
          ),
        ),
      ),
      SelectableText.rich(
        TextSpan(
          text: 'Pagamento e taxas',
          style: getDefaultFont(
            fontSize: paragraphSize,
          ),
        ),
      ),
      SelectableText.rich(
        TextSpan(
          text:
              'Os métodos de pagamento disponíveis serão mostrados ao cliente no ato da assinatura, o pagamento eletrônico será mostrado apenas se disponível.',
          style: getDefaultFont(
            fontSize: paragraphSize,
          ),
        ),
      ),
      SelectableText.rich(
        TextSpan(
          text: 'Os métodos de pagamento podem variar.',
          style: getDefaultFont(
            fontSize: paragraphSize,
          ),
        ),
      ),
      SelectableText.rich(
        TextSpan(
          text:
              'Todos os seus dados bancários, detalhes de cartão de crédito e outros métodos de pagamento são criptografados e nunca são armazenados em nosso site e/ou aplicativo. Usamos soluções de terceiros para processar seu pagamento.',
          style: getDefaultFont(
            fontSize: paragraphSize,
          ),
        ),
      ),
      SelectableText.rich(
        TextSpan(
          text:
              'Reservamo-nos o direito de modificar a qualquer momento quaisquer taxas, se você não concordar com a mudança de preço, você pode parar de usar nossos serviços a qualquer momento antes do pagamento da renovação.',
          style: getDefaultFont(
            fontSize: paragraphSize,
          ),
        ),
      ),
      SelectableText.rich(
        TextSpan(
          text:
              'Compras no aplicativo (IAP) para acessar conteúdo restrito (artigos, vídeos, blog, desbloqueio de conteúdo ou recursos exclusivos)',
          style: getDefaultFont(
            fontSize: paragraphSize,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      SelectableText.rich(
        TextSpan(
          text:
              'Se você se inscreveu por meio de terceiros, como Google Play, Apple App Store ou qualquer outro terceiro, estes Termos e Condições podem não se aplicar a você. Nesse caso, o contrato para tais produtos será com o terceiro e não com a nossa empresa.',
          style: getDefaultFont(
            fontSize: paragraphSize,
          ),
        ),
      ),
      SelectableText.rich(
        TextSpan(
          text:
              'Nossa empresa não será responsável por quaisquer reclamações relacionadas a compras feitas por meio de terceiros, você deve entrar em contato diretamente com esse terceiro.',
          style: getDefaultFont(
            fontSize: paragraphSize,
          ),
        ),
      ),
      SelectableText.rich(
        TextSpan(
          text:
              'Restaurando sua assinatura, conteúdo digital ou compras no aplicativo',
          style: getDefaultFont(
            fontWeight: FontWeight.bold,
            fontSize: paragraphSize,
          ),
        ),
      ),
      SelectableText.rich(
        TextSpan(
          text:
              'Se você tiver feito compras no aplicativo (IAP) por meio de terceiros, poderá restaurar suas compras anteriores já feitas. Isso pode ser feito usando o link em nosso Aplicativo e/ou site.',
          style: getDefaultFont(
            fontSize: paragraphSize,
          ),
        ),
      ),
      SelectableText.rich(
        TextSpan(
          text: 'Artigo 4 - Processo de registro',
          style: getDefaultFont(
            fontWeight: FontWeight.bold,
            fontSize: sectionSize,
          ),
        ),
      ),
      SelectableText.rich(
        TextSpan(
          text:
              'Nossa empresa exige que nosso cliente primeiro se registre para permitir que o cliente acesse todo o aplicativo e/ou site.',
          style: getDefaultFont(
            fontSize: paragraphSize,
          ),
        ),
      ),
      SelectableText.rich(
        TextSpan(
          text:
              'Cada registro é destinado a apenas um usuário e você está proibido de compartilhar suas credenciais ou sua conta com qualquer pessoa.',
          style: getDefaultFont(
            fontSize: paragraphSize,
          ),
        ),
      ),
      SelectableText.rich(
        TextSpan(
          text:
              'Podemos cancelar ou suspender seu acesso aos nossos Serviços se você compartilhar suas credenciais.',
          style: getDefaultFont(
            fontSize: paragraphSize,
          ),
        ),
      ),
      SelectableText.rich(
        TextSpan(
          text: 'Notifique-nos imediatamente em contato@vidalongaapp.com',
          style: getDefaultFont(
            fontSize: paragraphSize,
          ),
        ),
      ),
      SelectableText.rich(
        TextSpan(
          text: 'Cadastro',
          style: getDefaultFont(
            fontWeight: FontWeight.bold,
            fontSize: paragraphSize,
          ),
        ),
      ),
      SelectableText.rich(
        TextSpan(
          text:
              """Se o registro for necessário para acessar nosso site e/ou aplicativo, o cliente deve primeiro se registrar criando uma conta.
Para tal o cliente deverá preencher o formulário de registro disponível no nosso website e/ou aplicação. O cliente escolherá um login e uma senha vinculados a um endereço de e-mail válido.""",
          style: getDefaultFont(
            fontSize: paragraphSize,
          ),
        ),
      ),
      SelectableText.rich(
        TextSpan(
          text:
              'Ao fazê-lo, o cliente concorda que manterá suas credenciais confidenciais, seguras em todos os momentos e que não as comunicará a terceiros.',
          style: getDefaultFont(
            fontSize: paragraphSize,
          ),
        ),
      ),
      SelectableText.rich(
        TextSpan(
          text:
              'O cliente deve manter sua credencial confidencial em todos os momentos e não deve compartilhar suas credenciais com ninguém.',
          style: getDefaultFont(
            fontSize: paragraphSize,
          ),
        ),
      ),
      SelectableText.rich(
        TextSpan(
          text:
              'A nossa empresa não será responsabilizada por qualquer uso, modificação ou acesso não autorizado à conta do cliente, mesmo que o acesso fraudulento seja feito usando a conta do cliente ou dados bancários.',
          style: getDefaultFont(
            fontSize: paragraphSize,
          ),
        ),
      ),

      SelectableText.rich(
        TextSpan(
          text: 'Artigo 5 - Garantias',
          style: getDefaultFont(
            fontWeight: FontWeight.bold,
            fontSize: sectionSize,
          ),
        ),
      ),
      SelectableText.rich(
        TextSpan(
          text:
              'O conteúdo fornecido por nossos serviços é fornecido ao usuário (como está) e (conforme disponível), não podemos garantir que o conteúdo fornecido seja exato, verdadeiro ou livre de erros. O usuário acessa nosso conteúdo por sua conta e risco.',
          style: getDefaultFont(
            fontSize: paragraphSize,
          ),
        ),
      ),
      SelectableText.rich(
        TextSpan(
          text:
              'Não seremos responsabilizados se algum conteúdo de nossos serviços for impreciso ou equivocado.',
          style: getDefaultFont(
            fontSize: paragraphSize,
          ),
        ),
      ),
      SelectableText.rich(
        TextSpan(
          text:
              'Artigo 6 - Moderação de conteúdo (chat, comentários e outros) e conteúdo gerado pelo usuário',
          style: getDefaultFont(
            fontSize: paragraphSize,
          ),
        ),
      ),
      SelectableText.rich(
        TextSpan(
          text:
              'Se nosso usuário fizer upload, postar ou enviar qualquer tipo de conteúdo nos serviços, você representa para nós que possui todos os direitos legais necessários para fazer upload, postar ou enviar tal conteúdo.',
          style: getDefaultFont(
            fontSize: paragraphSize,
          ),
        ),
      ),
      SelectableText.rich(
        TextSpan(
          text:
              'Você não deve publicar, distribuir ou fazer upload de qualquer conteúdo que seja abusivo, fake news, obsceno, pornográfico, ilegal.',
          style: getDefaultFont(
            fontSize: paragraphSize,
          ),
        ),
      ),
      SelectableText.rich(
        TextSpan(
          text:
              'Além disso, você não deve tentar se passar por outra pessoa ou usar uma identidade falsa para usar, acessar ou publicar qualquer conteúdo em nossos serviços.',
          style: getDefaultFont(
            fontSize: paragraphSize,
          ),
        ),
      ),
      SelectableText.rich(
        TextSpan(
          text:
              'Você não deve usar nossos serviços para transmitir qualquer tipo de malware, vírus, cripto lockers, ransomware ou spyware.',
          style: getDefaultFont(
            fontSize: paragraphSize,
          ),
        ),
      ),
      SelectableText.rich(
        TextSpan(
          text:
              'Os usuários não ameaçarão ou abusarão verbalmente de outros usuários nem enviarão spam aos serviços. O usuário usará uma linguagem respeitosa, você não tentará abusar ou discriminar com base em raça, religião, nacionalidade, sexo ou preferência sexual, idade, deficiência e assim por diante. O discurso de ódio é proibido.',
          style: getDefaultFont(
            fontSize: paragraphSize,
          ),
        ),
      ),
      SelectableText.rich(
        TextSpan(
          text:
              'Não seremos responsabilizados se algum conteúdo de nossos serviços for impreciso ou equivocado.',
          style: getDefaultFont(
            fontSize: paragraphSize,
          ),
        ),
      ),
      SelectableText.rich(
        TextSpan(
          text:
              'Artigo 6 - Moderação de conteúdo (chat, comentários e outros) e conteúdo gerado pelo usuário',
          style: getDefaultFont(
            fontSize: sectionSize,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      SelectableText.rich(
        TextSpan(
          text:
              'Se nosso usuário fizer upload, postar ou enviar qualquer tipo de conteúdo nos serviços, você representa para nós que possui todos os direitos legais necessários para fazer upload, postar ou enviar tal conteúdo.',
          style: getDefaultFont(
            fontSize: paragraphSize,
          ),
        ),
      ),
      SelectableText.rich(
        TextSpan(
          text:
              'Você não deve publicar, distribuir ou fazer upload de qualquer conteúdo que seja abusivo, fake news, obsceno, pornográfico, ilegal.',
          style: getDefaultFont(
            fontSize: paragraphSize,
          ),
        ),
      ),
      SelectableText.rich(
        TextSpan(
          text:
              'Além disso, você não deve tentar se passar por outra pessoa ou usar uma identidade falsa para usar, acessar ou publicar qualquer conteúdo em nossos serviços.',
          style: getDefaultFont(
            fontSize: paragraphSize,
          ),
        ),
      ),
      SelectableText.rich(
        TextSpan(
          text:
              'Você não deve usar nossos serviços para transmitir qualquer tipo de malware, vírus, cripto lockers, ransomware ou spyware.',
          style: getDefaultFont(
            fontSize: paragraphSize,
          ),
        ),
      ),
      SelectableText.rich(
        TextSpan(
          text:
              'Os usuários não ameaçarão ou abusarão verbalmente de outros usuários nem enviarão spam aos serviços. O usuário usará uma linguagem respeitosa, você não tentará abusar ou discriminar com base em raça, religião, nacionalidade, sexo ou preferência sexual, idade, deficiência e assim por diante. O discurso de ódio é proibido.',
          style: getDefaultFont(
            fontSize: paragraphSize,
          ),
        ),
      ),
      SelectableText.rich(
        TextSpan(
          text:
              'Nossa empresa tem o direito de excluir, modificar, censurar e excluir o conteúdo ou a conta de um cliente se qualquer uma das regras acima for violada. Isso será feito sem qualquer justificativa ou aviso prévio. O cliente não receberá nenhuma compensação.',
          style: getDefaultFont(
            fontSize: paragraphSize,
          ),
        ),
      ),
      SelectableText.rich(
        TextSpan(
          text: 'Artigo 7 - Responsabilidade',
          style: getDefaultFont(
            fontSize: sectionSize,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      SelectableText.rich(
        TextSpan(
          text:
              'Nossa empresa não será responsável em caso de interrupção de rede, vírus, acesso externo, uso fraudulento de métodos de pagamento ou qualquer outro tipo ou tipo de problema técnico ou acesso fraudulento.',
          style: getDefaultFont(
            fontSize: paragraphSize,
          ),
        ),
      ),
      SelectableText.rich(
        TextSpan(
          text: 'Artigo 8 - Links de terceiros e links externos',
          style: getDefaultFont(
            fontSize: sectionSize,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      SelectableText.rich(
        TextSpan(
          text:
              'Alguns dos conteúdos disponíveis em nosso site e/ou aplicativo podem incluir materiais de terceiros e fontes externas. Links de terceiros em nossos sites e/ou aplicativos podem direcioná-lo para fora de nossos sites de controle que não são afiliados a nós. Não somos responsáveis por controlar ou examinar o conteúdo ou precisão de sites de terceiros ou fontes externas.',
          style: getDefaultFont(
            fontSize: paragraphSize,
          ),
        ),
      ),
      SelectableText.rich(
        TextSpan(
          text:
              'Portanto, não somos responsáveis por quaisquer danos ou uso indevido ao acessar links de terceiros ou links externos ou fontes em nosso site e/ou aplicativo.',
          style: getDefaultFont(
            fontSize: paragraphSize,
          ),
        ),
      ),
      SelectableText.rich(
        TextSpan(
          text:
              'Leia atentamente nossa política de privacidade sobre como lidar com a política de privacidade, termos e condições e política de cookies de terceiros.',
          style: getDefaultFont(
            fontSize: paragraphSize,
          ),
        ),
      ),
      SelectableText.rich(
        TextSpan(
          text: 'Artigo 9 - Renúncia de garantias',
          style: getDefaultFont(
            fontSize: sectionSize,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      SelectableText.rich(
        TextSpan(
          text:
              'Ao usar nosso site e/ou aplicativo, você nos garante que não seremos responsabilizados se os dados em nossos serviços não forem precisos, verdadeiros, completos ou corretos. As informações e dados fornecidos em nossos serviços são fornecidos apenas como ilustração e informação e não devem ser usados para a tomada de decisões. Mais conselhos e informações devem ser procurados antes de tomar qualquer decisão séria. Você está usando nossos serviços por sua conta e risco.',
          style: getDefaultFont(
            fontSize: paragraphSize,
          ),
        ),
      ),
      SelectableText.rich(
        TextSpan(
          text:
              'Ao usar nosso site e/ou aplicativo, você nos garante que não seremos responsabilizados se os dados em nossos serviços não forem precisos, verdadeiros, completos ou corretos. As informações e dados fornecidos em nossos serviços são fornecidos apenas como ilustração e informação e não devem ser usados para a tomada de decisões. Mais conselhos e informações devem ser procurados antes de tomar qualquer decisão séria. Você está usando nossos serviços por sua conta e risco.',
          style: getDefaultFont(
            fontSize: paragraphSize,
          ),
        ),
      ),
      SelectableText.rich(
        TextSpan(
          text:
              'Nossa empresa se reserva o direito de modificar e/ou excluir qualquer conteúdo de nossos serviços sem aviso prévio, mas nossa empresa não tem obrigação de atualizar qualquer conteúdo disponível em nossos serviços.',
          style: getDefaultFont(
            fontSize: paragraphSize,
          ),
        ),
      ),
      SelectableText.rich(
        TextSpan(
          text:
              'Além disso, nossa empresa não garante que o uso de nossos serviços seja livre de erros, oportuno, seguro ou ininterrupto. O cliente concorda que podemos remover serviços de tempos em tempos ou adicionar novos sem aviso prévio.',
          style: getDefaultFont(
            fontSize: paragraphSize,
          ),
        ),
      ),
      SelectableText.rich(
        TextSpan(
          text:
              'Nossos serviços são entregues e fornecidos aos clientes "como estão" e "conforme disponíveis" para uso, sem quaisquer garantias ou condições de qualquer tipo.',
          style: getDefaultFont(
            fontSize: paragraphSize,
          ),
        ),
      ),
      SelectableText.rich(
        TextSpan(
          text:
              'Em nenhum caso, a equipe, funcionários, agentes, estagiários e assim por diante de nossa empresa não são responsáveis por qualquer perda, reclamação, lesão, qualquer dano indireto ou direto, danos incidentais, punitivos ou especiais de qualquer tipo ou tipo. Isso inclui perda de lucros, muitas receitas, muitos dados ou economias, seja com base na lei de responsabilidade civil, contrato, responsabilidade ou de outra forma.',
          style: getDefaultFont(
            fontSize: paragraphSize,
          ),
        ),
      ),
      SelectableText.rich(
        TextSpan(
          text: 'Artigo 10 - Indenização',
          style: getDefaultFont(
            fontSize: sectionSize,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      SelectableText.rich(
        TextSpan(
          text:
              'Você, como cliente de nossa empresa, concorda em indenizar, defender e isentar-nos de qualquer reclamação ou demanda, incluindo honorários advocatícios feitos por terceiros devido à sua violação destes Termos e Condições ou qualquer outro documento que seja vinculativo entre você e nosso empresa.',
          style: getDefaultFont(
            fontSize: paragraphSize,
          ),
        ),
      ),
      SelectableText.rich(
        TextSpan(
          text: 'Artigo 11 - Divisibilidade',
          style: getDefaultFont(
            fontSize: sectionSize,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      SelectableText.rich(
        TextSpan(
          text:
              'Se qualquer parte, artigo ou documento destes Termos e Condições ou de qualquer outro documento vinculativo entre você e nossa empresa for determinado por uma jurisdição competente como ilegal, nulo ou inexequível, tal disposição deverá, no entanto, ser aplicável em toda a extensão permitida pela lei aplicável.',
          style: getDefaultFont(
            fontSize: paragraphSize,
          ),
        ),
      ),
      SelectableText.rich(
        TextSpan(
          text:
              'A parte inexequível será considerada separada destes Termos e Condições, tal determinação não afetará a validade e exequibilidade de quaisquer outras disposições restantes.',
          style: getDefaultFont(
            fontSize: paragraphSize,
          ),
        ),
      ),
      SelectableText.rich(
        TextSpan(
          text: 'Artigo 12 - Rescisão',
          style: getDefaultFont(
            fontSize: sectionSize,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      SelectableText.rich(
        TextSpan(
          text:
              'Todas as obrigações e responsabilidades das partes que ocorreram antes da data de rescisão sobreviverão à rescisão deste contrato.',
          style: getDefaultFont(
            fontSize: paragraphSize,
          ),
        ),
      ),
      SelectableText.rich(
        TextSpan(
          text:
              'O cliente pode comunicar à nossa empresa que não pretende mais utilizar os nossos serviços ou pode simplesmente deixar de utilizar e/ou aceder aos nossos serviços, websites e/ou aplicação.',
          style: getDefaultFont(
            fontSize: paragraphSize,
          ),
        ),
      ),
      SelectableText.rich(
        TextSpan(
          text:
              'Nossa empresa pode rescindir este contrato a seu exclusivo critério a qualquer momento e sem aviso prévio, portanto, o cliente permanecerá responsável por quaisquer valores remanescentes devidos à nossa empresa.',
          style: getDefaultFont(
            fontSize: paragraphSize,
          ),
        ),
      ),
      SelectableText.rich(
        TextSpan(
          text: 'Artigo 13 - Lei Aplicável',
          style: getDefaultFont(
            fontSize: sectionSize,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      SelectableText.rich(
        TextSpan(
          text: 'Modificações',
          style: getDefaultFont(
            fontSize: paragraphSize,
          ),
        ),
      ),
      SelectableText.rich(
        TextSpan(
          text:
              'O Vida Longa pode revisar estes termos de serviço do site a qualquer momento, sem aviso prévio. Ao usar este site, você concorda em ficar vinculado à versão atual desses termos de serviço.',
          style: getDefaultFont(
            fontSize: paragraphSize,
          ),
        ),
      ),
      SelectableText.rich(
        TextSpan(
          text: 'Lei aplicável',
          style: getDefaultFont(
            fontSize: paragraphSize,
          ),
        ),
      ),
      SelectableText.rich(
        TextSpan(
          text:
              'Estes termos e condições são regidos e interpretados de acordo com as leis do Vida Longa e você se submete irrevogavelmente à jurisdição exclusiva dos tribunais naquele estado ou localidade.',
          style: getDefaultFont(
            fontSize: paragraphSize,
          ),
        ),
      ),
      SelectableText.rich(
        TextSpan(
          text: 'Artigo 14 - Informações de contato',
          style: getDefaultFont(
            fontSize: sectionSize,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      SelectableText.rich(
        TextSpan(
          text:
              'Se você tiver alguma dúvida sobre estes Termos e Condições, entre em contato conosco diretamente em: contato@vidalongaapp.com.',
          style: getDefaultFont(
            fontSize: paragraphSize,
          ),
        ),
      ),
      SelectableText.rich(
        TextSpan(
          text: 'Cancelamento e reembolso',
          style: getDefaultFont(
            fontSize: sectionSize,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      SelectableText.rich(
        TextSpan(
          text:
              'Caso o usuário cancele sua assinatura, o cancelamento ocorrerá apenas para cobranças futuras associadas a essa assinatura. Você pode nos notificar sobre seu cancelamento a qualquer momento e esse cancelamento ocorrerá no final do seu período de cobrança atual.',
          style: getDefaultFont(
            fontSize: paragraphSize,
          ),
        ),
      ),
      SelectableText.rich(
        TextSpan(
          text:
              'Você não receberá reembolso pelo ciclo de cobrança atual, os usuários continuarão a ter o mesmo acesso e benefícios de seus produtos pelo restante do período de cobrança atual.',
          style: getDefaultFont(
            fontSize: paragraphSize,
          ),
        ),
      ),
      SelectableText.rich(
        TextSpan(
          text:
              'Você pode obter um reembolso parcial ou total, dependendo de onde você mora e com base na legislação e regulamentação aplicáveis.',
          style: getDefaultFont(
            fontSize: paragraphSize,
          ),
        ),
      ),
      SelectableText.rich(
        TextSpan(
          text:
              'Nossa empresa se reserva o direito de emitir reembolsos ou créditos a nosso exclusivo critério.',
          style: getDefaultFont(
            fontSize: paragraphSize,
          ),
        ),
      ),
      SelectableText.rich(
        TextSpan(
          text:
              'Se o IAP for feito dentro de nossos Serviços, você deve verificar os Termos e Condições da Loja sobre como gerenciar e obter seu reembolso ou cancelamento. Você pode verificar a condição deles em https://support.apple.com/pt-br/HT204084 para Apple ou em https://support.google.com/googleplay/answer/2479637?hl=pt-BR para Google.',
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
