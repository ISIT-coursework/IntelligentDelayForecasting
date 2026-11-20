// Пользователи и контейнеры.
dispatcher -> web "Контролирует доставки и прогнозы" "HTTPS"
dispatcher -> mobile "Проверяет прогноз в пути" "HTTPS"
analyst -> web "Просматривает аналитику задержек" "HTTPS"
administrator -> web "Настраивает доступ и интеграции" "HTTPS"
web -> api "Запрашивает доставки и прогнозы" "JSON/HTTPS"
mobile -> api "Запрашивает статусы и риск задержки" "JSON/HTTPS"
api -> database "Читает и сохраняет доставки и прогнозы" "SQL/TCP"
transport -> api "Передаёт статусы и плановые сроки" "JSON/HTTPS"
api -> maps "Запрашивает параметры маршрута" "JSON/HTTPS"

// Участник 1: интерфейс и вызовы API.
dashboard -> deliveryList "Отображает список доставок" "TypeScript function call"
dashboard -> forecastChart "Отображает графики риска" "TypeScript function call"
deliveryList -> apiClient "Запрашивает статусы доставок" "TypeScript function call"
forecastChart -> apiClient "Запрашивает прогноз задержки" "TypeScript function call"
apiClient -> deliveryEndpoint "Получает список доставок" "JSON/HTTPS"
apiClient -> forecastEndpoint "Запрашивает прогноз доставки" "JSON/HTTPS"
mobile -> deliveryEndpoint "Получает статусы доставок" "JSON/HTTPS"
mobile -> forecastEndpoint "Получает прогноз доставки" "JSON/HTTPS"

// Участник 2: проверка доступа и бизнес-сценарий.
deliveryEndpoint -> accessControl "Проверяет доступ к списку доставок" "Go function call"
forecastEndpoint -> accessControl "Проверяет доступ к прогнозу" "Go function call"
deliveryEndpoint -> deliveryRepository "Читает доставки" "Go function call"
forecastEndpoint -> forecastCoordinator "Запрашивает сохранённую оценку риска рейса" "Go function call"
forecastCoordinator -> deliveryRepository "Читает историю и сохраняет результат" "Go function call"

// Участник 4: получение, проверка и сохранение данных.
transport -> dataImporter "Передаёт обновления статусов доставок" "JSON/HTTPS"
dataImporter -> dataValidator "Проверяет входящие данные" "Go function call"
dataValidator -> dataNormalizer "Передаёт проверенные данные" "Go function call"
dataNormalizer -> maps "Получает параметры маршрута" "JSON/HTTPS"
dataNormalizer -> deliveryRepository "Сохраняет нормализованную доставку" "Go function call"
deliveryRepository -> database "Читает и записывает данные" "SQL/TCP"

// Предиктор и обучение
api -> kafka "Публикует события рейсов и получает результаты прогнозирования" "Kafka protocol / TCP"
forecastCoordinator -> kafka "Публикует снимки рейсов и получает оценки риска" "Kafka protocol / TCP"
predictor -> kafka "Читает снимки рейсов и публикует риск задержки и версию модели" "Kafka protocol / TCP"
predictor -> objects "Загружает версию модели и схему признаков" "S3 API / HTTPS"
training -> analytics "Читает исторические снимки и результаты рейсов" "ClickHouse native protocol / TCP"
training -> objects "Сохраняет проверенные модели и метрики" "S3 API / HTTPS"

// RAG и поиск регламентов
api -> rag "Передаёт вопрос, контекст рейса и разрешённые версии регламентов" "HTTP / JSON"
rag -> vectors "Ищет доступные фрагменты регламентов" "HTTP / JSON"
rag -> llmProvider "Запрашивает генерацию ответа по найденным фрагментам" "HTTPS / JSON"

api -> ragApi "Передаёт вопрос и проверенные ограничения поиска" "HTTP / JSON"
ragApi -> ragOrchestrator "Передаёт проверенный запрос" "Python function call"
ragOrchestrator -> queryEncoder "Получает эмбеддинг вопроса" "Python function call"
ragOrchestrator -> regulationSearch "Передаёт вектор вопроса и ограничения поиска" "Python function call"
ragOrchestrator -> promptBuilder "Передаёт вопрос, факты рейса и найденные фрагменты" "Python function call"
ragOrchestrator -> llmClient "Запрашивает генерацию по подготовленному промпту" "Python function call"
ragOrchestrator -> answerBuilder "Передаёт результат генерации и допустимые источники" "Python function call"
regulationSearch -> vectors "Ищет фрагменты по вектору и фильтрам" "HTTP / JSON"
llmClient -> llmProvider "Запрашивает генерацию ответа" "HTTPS / JSON"