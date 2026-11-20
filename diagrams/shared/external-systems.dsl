transport = softwareSystem "Транспортная система" "Предоставляет статусы, маршруты и плановые сроки доставок." {
    tags "External"
}
weather = softwareSystem "Сервис погоды" "Предоставляет погодные условия по маршруту доставки." {
    tags "External"
}
maps = softwareSystem "Картографический сервис" "Предоставляет расстояния и оценку времени движения по маршруту." {
    tags "External"
}

llmProvider = softwareSystem "Провайдер LLM API" "Генерирует ответы по вопросу и переданным фрагментам регламентов." {
    tags "External"
}
