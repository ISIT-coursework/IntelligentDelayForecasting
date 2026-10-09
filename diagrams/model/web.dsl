// Участник 1: интерфейсы пользователя.
web = container "Веб-интерфейс" "Показывает доставки, аналитику и прогнозы задержек." "React / TypeScript" {
    dashboard = component "Панель мониторинга" "Объединяет список доставок и графики прогноза." "React / TypeScript"
    deliveryList = component "Список доставок" "Показывает текущие статусы и плановые сроки." "React / TypeScript"
    forecastChart = component "Графики прогноза" "Показывает риск и ожидаемую длительность задержки." "React / TypeScript"
    apiClient = component "Клиент API" "Запрашивает данные доставок и прогнозов." "TypeScript / Fetch API"
}
mobile = container "Мобильное приложение" "Позволяет диспетчеру проверять риск задержки в пути." "React Native / TypeScript"
