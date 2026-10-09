workspace "Intelligent Delay Forecasting — test" "Тестовые C4-диаграммы системы прогнозирования задержек доставки." {
    model {
        dispatcher = person "Диспетчер" "Проверяет прогнозы задержек и планирует доставки."

        forecasting = softwareSystem "Прогнозирование задержек" "Оценивает риск и ожидаемую длительность задержки доставки." {
            web = container "Веб-интерфейс" "Показывает доставки и прогнозы задержек." "Web application"
            api = container "API" "Принимает данные доставки и возвращает прогноз." "Go"
            predictor = container "Модель прогнозирования" "Рассчитывает прогноз по признакам доставки." "Python"
            database = container "База данных" "Хранит доставки, историю и результаты прогнозов." "PostgreSQL" {
                tags "Database"
            }
        }

        transport = softwareSystem "Транспортная система" "Источник статусов и плановых сроков доставки." {
            tags "External"
        }

        dispatcher -> web "Просматривает прогнозы" "HTTPS"
        web -> api "Запрашивает доставки и прогнозы" "JSON/HTTPS"
        transport -> api "Передаёт статусы доставок" "JSON/HTTPS"
        api -> database "Читает и сохраняет данные" "SQL"
        api -> predictor "Запрашивает прогноз" "JSON/HTTP"
    }

    views {
        systemContext forecasting "SystemContext" {
            include *
            autoLayout lr
        }

        container forecasting "Containers" {
            include *
            autoLayout lr
        }

        styles {
            element "Element" {
                color #ffffff
            }
            element "Person" {
                shape Person
                background #08427b
            }
            element "Software System" {
                background #1168bd
            }
            element "Container" {
                background #438dd5
            }
            element "Database" {
                shape Cylinder
            }
            element "External" {
                background #666666
            }
        }
    }
}
