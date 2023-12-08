import 'package:app_vida_longa/shared/widgets/custom_scaffold.dart';
import 'package:app_vida_longa/src/core/navigation_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_html_iframe/flutter_html_iframe.dart';

class ArticleView extends StatefulWidget {
  const ArticleView({super.key});

  @override
  State<ArticleView> createState() => _ArticleViewState();
}

class _ArticleViewState extends State<ArticleView> {
  double fontSize = 16.0;

  @override
  Widget build(BuildContext context) {
    return CustomAppScaffold(
      appBar: AppBar(title: const Text("Artigo")),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Html(
                           
              style: {"body": Style(fontSize: FontSize(fontSize))},
              data: r'''
                      <p>Embora muitas vezes negligenciada, a fome oculta é um problema de saúde pública global que afeta milhões de pessoas. Diferente da fome tradicional, que é visível e se refere à falta de alimentos, a fome oculta acontece quando uma pessoa não recebe nutrientes suficientes. Este artigo aborda a fome oculta de forma acessível, visando conscientizar o público leigo sobre suas causas, consequências e como preveni-la.</p>
                      <blockquote>
                      <p><strong>O que é fome oculta?</strong></p>
                      </blockquote>
                      <p>A fome oculta refere-se à deficiência de vitaminas e minerais no corpo, apesar da ingestão adequada de calorias. É "oculta" porque muitas vezes não há sinais externos óbvios, como a magreza extrema associada à desnutrição. Essa condição pode afetar pessoas de todas as idades, mas é particularmente preocupante em crianças, que necessitam de uma variedade de nutrientes para um crescimento e desenvolvimento saudável.</p>
                      <blockquote>
                      <p><strong>Causas comuns</strong><br />
                      As principais causas da fome oculta incluem:</p>
                      </blockquote>
                      <ul>
                        <li><strong>Dietas desbalanceadas: </strong>Consumir alimentos com alto teor calórico, mas pobres em nutrientes essenciais.</li>
                        <li><strong>Acesso limitado a alimentos variados:</strong> Dificuldades econômicas podem restringir o acesso a uma dieta diversificada.</li>
                        <li><strong>Desinformação nutricional:</strong> Falta de conhecimento sobre a importância de uma dieta balanceada.</li>
                      </ul>
                      <blockquote>
                      <p><strong>Impactos na saúde</strong><br />
                      A fome oculta pode levar a uma série de problemas de saúde, incluindo:</p>
                      </blockquote>
                      <ul>
                        <li><strong>Desenvolvimento comprometido:</strong> Em crianças, pode resultar em atrasos no crescimento e no desenvolvimento cognitivo.</li>
                        <li><strong>Sistema imunológico fraco:</strong> Aumenta a suscetibilidade a infecções e doenças.</li>
                        <li><strong>Problemas de saúde a longo prazo:</strong> Pode contribuir para condições crônicas como anemia, osteoporose e problemas cardíacos.</li>
                      </ul>
                      <blockquote>
                      <p><strong>Estratégias de Prevenção</strong><br />
                      Prevenir a fome oculta envolve várias abordagens:</p>
                      </blockquote>
                      <ul>
                        <li><strong>Educação nutricional: </strong>Aprender sobre a importância de uma dieta equilibrada e rica em diversos nutrientes.</li>
                        <li><strong>Inclusão de alimentos diversos: </strong>Incluir uma variedade de frutas, vegetais, grãos integrais, proteínas e laticínios na dieta.</li>
                        <li><strong>Fortificação de alimentos: </strong>Consumir alimentos fortificados, como cereais e leites, que têm vitaminas e minerais adicionados.</li>
                      </ul>
                      <blockquote>
                      <p><strong>Conclusão</strong></p>
                      </blockquote>
                      <p>A fome oculta é um problema de saúde pública complexo, mas com educação e acesso a uma dieta variada, pode ser prevenido e controlado. Reconhecer a importância de uma alimentação rica em nutrientes é o primeiro passo para combater esse tipo de desnutrição, garantindo uma vida mais saudável para todos.</p>
                      
                      <!-- Imagem com Link -->
                      <img src="https://via.placeholder.com/150" alt="Imagem de Placeholder">

                      <!-- Imagem em Base64 -->
                      <img src="data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAJYAAADICAIAAACF548yAAACF0lEQVR4nO3bMQrDMBAAQSv4/19WunRpJIG9MNPbCJazG92Yc16UfZ4+ALskzJMwT8I8CfMkzJMwT8I8CfMkzJMwT8I8CfMkzJMwT8I8CfMkzJMwT8I8CfMkzJMwT8I8CfMkzJMwT8I8CfMunYfHOHUMruUNM1OYJ2He1of0x5rpsv2fkSnMkzBPwjwJ8yTMkzBPwjwJ8yTMkzBPwjwJ8yTMkzBPwjwJ8yTMkzBPwjwJ8yTMkzBPwjwJ8yTMkzBPwjwJ8yTMkzDvzIX88167NPW+3QNTmCdhnoR5EuZJmCdhnoR5EuZJmCdhnoR5EuZJmCdhnoR5EuZJmCdhnoR5EuZJmCdhnoR5EuZJmCdhnoR5EuZJmCdhnoR5EuZJmCdhnoR5EuZJmCdhnoR5EuZJmCdhnoR5EuZJmCdhnoR5EuZJmCdhnoR5EuZJmCdhnoR5EuZJmCdhnoR5EuZJmCdhnoR5EuZJmCdhnoR5EuZJmCdhnoR5EuZJmCdhnoR5EuZJmCdhnoR5EuZJmCdhnoR5EubdTx/gjzmfPkGGKcyTME/CPAnzJMyTME/CPAnzJMyTME/CPAnzJMyTME/CPAnzJMyTME/CPAnzJMyTME/CPAnzJMyTMO/MhfwxjryGFaYwT8K8rQ+p9aM3MIV5EuZJmCdhnoR5EuZJmCdhnoR5EuZJmCdhnoR5EuZJmCdhnoR5EuZJmCdhnoR5EuZJmCdhnoR5EuZJmCdh3hfKQQ6XEtgK4QAAAABJRU5ErkJggg==" alt="Ponto Vermelho">

                      '''
              ,
            ),
            Html(
              extensions: const [
                IframeHtmlExtension(),
              ],
              data:
                  '<iframe width="560" height="315" src="https://www.youtube.com/embed/UCq_V3NqanY" frameborder="0" allowfullscreen></iframe>',
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        height: 50,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            IconButton(
                onPressed: () {
                  NavigationController.push("/app/home/comments");
                },
                icon: const Icon(Icons.comment_rounded)),
            IconButton(
              icon: const Icon(Icons.zoom_out),
              onPressed: () => setState(() {
                fontSize = fontSize > 10 ? fontSize - 2 : 10;
              }),
            ),
            IconButton(
              icon: const Icon(Icons.zoom_in),
              onPressed: () => setState(() {
                fontSize += 2;
              }),
            ),
          ],
        ),
      ),
    );
  }
}
