// Пользователи и контейнеры.
dispatcher -> web "Контролирует доставки и прогнозы" "HTTPS"
dispatcher -> mobile "Проверяет прогноз в пути" "HTTPS"
analyst -> web "Просматривает аналитику задержек" "HTTPS"
administrator -> web "Настраивает доступ и интеграции" "HTTPS"
web -> api "Запрашивает доставки и прогнозы" "JSON/HTTPS"
mobile -> api "Запрашивает статусы и риск задержки" "JSON/HTTPS"
api -> predictor "Запрашивает расчёт прогноза" "JSON/HTTP"
api -> database "Читает и сохраняет доставки и прогнозы" "SQL/TCP"
transport -> api "Передаёт статусы и плановые сроки" "JSON/HTTPS"
predictor -> weather "Запрашивает погоду на маршруте" "JSON/HTTPS"
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
forecastEndpoint -> forecastCoordinator "Запускает расчёт прогноза" "Go function call"
forecastCoordinator -> deliveryRepository "Читает историю и сохраняет результат" "Go function call"
forecastCoordinator -> predictionEndpoint "Передаёт параметры доставки для расчёта" "JSON/HTTP"

// Участник 3: последовательность расчёта модели.
predictionEndpoint -> featureBuilder "Подготавливает признаки доставки" "Python function call"
featureBuilder -> weather "Получает погодные признаки" "JSON/HTTPS"
featureBuilder -> delayEstimator "Передаёт признаки для оценки задержки" "Python function call"
delayEstimator -> riskClassifier "Передаёт задержку для определения риска" "Python function call"

// Участник 4: получение, проверка и сохранение данных.
transport -> dataImporter "Передаёт обновления статусов доставок" "JSON/HTTPS"
dataImporter -> dataValidator "Проверяет входящие данные" "Go function call"
dataValidator -> dataNormalizer "Передаёт проверенные данные" "Go function call"
dataNormalizer -> maps "Получает параметры маршрута" "JSON/HTTPS"
dataNormalizer -> deliveryRepository "Сохраняет нормализованную доставку" "Go function call"
deliveryRepository -> database "Читает и записывает данные" "SQL/TCP"
