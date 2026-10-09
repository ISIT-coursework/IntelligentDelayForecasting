// Участник 3: расчёт прогнозов.
predictor = container "Модель прогнозирования" "Оценивает ожидаемую задержку и уровень риска." "Python / FastAPI" {
    predictionEndpoint = component "API модели" "Принимает параметры доставки и возвращает результат расчёта." "Python / FastAPI"
    featureBuilder = component "Подготовка признаков" "Объединяет маршрут, историю и погодные условия." "Python"
    delayEstimator = component "Оценка задержки" "Рассчитывает ожидаемую длительность задержки." "Python / scikit-learn"
    riskClassifier = component "Классификация риска" "Определяет уровень риска по рассчитанной задержке." "Python"
}
