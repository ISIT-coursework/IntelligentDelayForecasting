workspace "Intelligent Delay Forecasting — team demo" "Тестовая общая модель четырёх участников; технологии и сценарии приведены для примера." {
    model {
        !include shared/people.dsl
        !include shared/external-systems.dsl

        forecasting = softwareSystem "Прогнозирование задержек" "Оценивает риск и ожидаемую длительность задержки доставки." {
            !include model/web.dsl
            !include model/api.dsl
            !include model/predictor.dsl
            !include model/data.dsl
        }

        !include shared/relationships.dsl
    }

    views {
        !include views/context.dsl
        !include views/containers.dsl
        !include views/web.dsl
        !include views/api.dsl
        !include views/predictor.dsl
        !include views/data.dsl
        !include shared/styles.dsl
    }
}
