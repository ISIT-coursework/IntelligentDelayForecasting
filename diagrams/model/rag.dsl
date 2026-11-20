rag = container "RAG-сервис" "Ищет действующие регламенты, вызывает LLM API и возвращает ответ со ссылками на источники" "Python, FastAPI, Sentence Transformers" {
    tags "MLContainer"

    group "Слой интерфейса" {
        ragApi = component "Контроллер вопросов" "Принимает запрос от основного API, проверяет структуру данных и возвращает результат" "FastAPI Router, Pydantic" {
            tags "PresentationLayer"
        }
    }

    group "Прикладной слой" {
        ragOrchestrator = component "Координатор RAG" "Управляет поиском и генерацией; при недостатке контекста формирует запрос уточнения" "Python" {
            tags "ApplicationLayer"
        }
    }

    group "Логика подготовки ответа" {
        promptBuilder = component "Подготовка промпта" "Объединяет вопрос, факты рейса и найденные фрагменты в контекст для LLM" "Python" {
            tags "DomainLayer"
        }

        answerBuilder = component "Проверка и оформление ответа" "Проверяет структуру и идентификаторы источников, формирует ссылки и итоговый статус" "Python, Pydantic" {
            tags "DomainLayer"
        }
    }

    group "Инфраструктурный слой" {
        queryEncoder = component "Векторизация вопроса" "Вычисляет эмбеддинг вопроса совместимой с индексом моделью" "Sentence Transformers" {
            tags "InfrastructureLayer"
        }

        regulationSearch = component "Поиск регламентов" "Выполняет поиск в Qdrant с обязательными фильтрами доступа и версий документов" "Python, qdrant-client" {
            tags "InfrastructureLayer"
        }

        llmClient = component "Клиент LLM API" "Отправляет подготовленный промпт провайдеру и обрабатывает ответ или ошибку API" "Python, HTTPX" {
            tags "InfrastructureLayer"
        }
    }
}

vectors = container "Векторная база регламентов" "Хранит фрагменты регламентов, их эмбеддинги и метаданные для фильтрации доступа." "Qdrant"