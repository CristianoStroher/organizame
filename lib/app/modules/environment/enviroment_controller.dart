import 'package:logger/logger.dart';
import 'package:organizame/app/core/notifier/defaut_change_notifer.dart';
import 'package:organizame/app/models/enviroment_object.dart';
import 'package:organizame/app/models/imagens_object.dart';
import 'package:organizame/app/modules/environment/widgets/generic_environment_page.dart';
import 'package:organizame/app/modules/tecnicalVisit/technicalVisit_controller.dart';
import 'package:organizame/app/services/enviroment/enviroment_service.dart';
import 'package:organizame/app/services/enviromentImages/enviroment_images_service.dart';

class EnviromentController extends DefautChangeNotifer {
  final TechnicalVisitController _controller; // Controller da visita técnica
  final EnviromentImagesService _imagenService; // Serviço de imagens do ambiente
  final EnviromentService _enviromentService; // Serviço de ambiente
  EnviromentObject? _currentEnvironment; // Ambiente atual
  GenericEnvironmentPage? _page; // Pagina do ambiente
  
  /* Metodos get para acessar o ambiente atual visto que ele é privado
  e não pode ser acessado diretamente. Isso é uma prática comum para garantir
  que o ambiente não seja alterado sem passar por um método de controle.
  */
  EnviromentObject? get currentEnvironment => _currentEnvironment;
  GenericEnvironmentPage? get page => _page;
  
  // Construtor da classe
  EnviromentController({
    required TechnicalVisitController controller,
    required EnviromentImagesService imagenService,
    required EnviromentService enviromentService,
  })  : _controller = controller,
        _imagenService = imagenService,
        _enviromentService = enviromentService;
        

  /* Meto abaixo é chamado no momento que o ambiente é inicializado
  o qual ele chama um metodo ensureCurrentVisit que esta na classe do controller da visita técnica
  que é responsável por setar a visita técnica atual bem como o ambiente atual
  se existir. Se não existir um ambiente ele cria um novo ambiente com um ID baseado no tempo atual.
  */  
  
  Future<void> _initializeEnvironment() async {
    try {
      await _controller.ensureCurrentVisit(); // metodo para pegar a visita técnica atual
      _currentEnvironment = _controller.currentEnvironment; // variavel para pegar o ambiente atual

      /* Verifica se o ambiente atual é nulo,
      se for cria um novo ambiente com um ID baseado no tempo atual */
      if (_currentEnvironment == null) {
        String newId = DateTime.now().millisecondsSinceEpoch.toString();
        Logger().d('Criando novo ambiente com ID: $newId');
     
       
        // Cria um novo ambiente com o ID gerado
        _currentEnvironment = EnviromentObject(
          id: newId,
          name: page?.title ?? 'Nome não Identificado', //! vamos ter que ter um campo para o nome do ambiente
          description: '',
          itens: {},
          imagens: [],
        );
        Logger().d('Novo ambiente salvo com ID: $newId');
      }

      Logger().d('Ambiente inicializado com ID: ${_currentEnvironment?.id}');
      notifyListeners();
    } catch (e) {
      Logger().e('Erro ao inicializar ambiente: $e');
      rethrow;
    }
  }
  
  //? Salva o ambiente no Firestore usa função addEnvironment do controller
  Future<EnviromentObject> saveEnvironment({ 
    required String description,
    required String metragem,
    String? difficulty,
    String? observation,
    required Map<String, bool> selectedItens,
    List<ImagensObject> listaImagens = const [],
  }) async {
    try {
      Logger().d('ChildBedroomController - Iniciando salvando ambiente');
      showLoadingAndResetState();
      
      // Verifica se o ambiente atual é nulo
      if (_currentEnvironment == null) {
        throw Exception('Erro: Ambiente atual não encontrado.');
      }
      // se não for nulo pega o ID do ambiente atual
      final environmentId = _currentEnvironment!.id.toString(); // Usar o ID existente tem que ser convertido para string

      Logger().d('Usando environment ID: $environmentId');

      final environment = EnviromentObject(
        id: environmentId, // Usar o ID existente
        name: page?.title ?? 'Nome não Identificado', //! vamos ter que ter um campo para o nome do ambiente
        description: description,
        metragem: metragem,
        difficulty: difficulty,
        observation: observation,
        itens: selectedItens,
        imagens: listaImagens ?? [], // Manter imagens existentes
      );
      Logger().d('Ambiente criado: $environment');
      Logger().d('Salvando ambiente com ID: ${environment.id}');
      await _controller.addEnvironment(environment);
      _currentEnvironment = environment;

      success();
      return environment;
    } catch (e) {
      setError('Erro ao salvar ambiente: $e');
      Logger().e('Erro ao salvar ambiente: $e');
      rethrow;
    } finally {
      hideLoading();
      notifyListeners();
    }
  }  

  //? Metodo para atualizar o ambiente no Firestore
  Future<void> updateEnvironment(EnviromentObject environment) async {
    try {
      // Logger().d('Atualizando ambiente: ${environment.id}');
      showLoadingAndResetState();
      final currentVisit = _controller.currentVisit?.id;// Pega a visita técnica atual
      if (currentVisit == null) { // Verifica se a visita técnica é nula
        throw Exception('Nenhuma visita selecionada');
      }
      // Logger().d('Tentando atualizar ambiente. CurrentVisit: ${currentVisit.toString()}');
      // Logger().d('Ambiente: ${environment.toString()}');
      await _controller.updateEnvironment(environment);
      _currentEnvironment = environment;
      
      success();
      Logger().d('Ambiente atualizado com sucesso');
    } catch (e) {
      Logger().e('Erro ao atualizar ambiente: $e');
      setError('Erro ao atualizar ambiente');
      rethrow;
    }
  }


}
