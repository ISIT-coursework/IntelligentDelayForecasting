// Веб-приложение и мобильный интерфейс.
web = container "Веб-приложение" "Браузерное React-приложение: навигация по роли, список и карточка рейса, чат с источниками, загрузка документов, статусы, уведомления и отчёты" "TypeScript, React" {
    tags "FrontendContainer"

    group "Слой интерфейса" {
        appShell = component "Оболочка приложения" "Отображает навигацию и открывает рабочие разделы с учётом роли пользователя" "TypeScript, React" {
            tags "UILayer"
        }

        tripsScreen = component "Рабочее место диспетчера" "Показывает ранжированные рейсы, фильтры и карточку рейса; позволяет фиксировать действия" "TypeScript, React" {
            tags "UILayer"
        }

        ragChat = component "Чат по регламентам" "Принимает вопрос по выбранному рейсу, показывает ответ, уточнения и ссылки на источники" "TypeScript, React" {
            tags "UILayer"
        }

        customerScreen = component "Кабинет заказчика" "Позволяет загружать регламенты, отслеживать обработку версий и читать уведомления" "TypeScript, React" {
            tags "UILayer"
        }

        reportsScreen = component "Панель отчётов" "Отображает сводки перевозок и рисков с выбором периода и фильтров" "TypeScript, React" {
            tags "UILayer"
        }
    }

    group "Слой состояния и сценариев" {
        sessionState = component "Состояние сеанса" "Хранит профиль и роль текущего пользователя, управляет загрузкой сеанса и выходом" "TypeScript, React Context" {
            tags "StateLayer"
        }

        queryStore = component "Модуль данных и действий" "Загружает данные экранов, выполняет действия, управляет кэшем и состояниями загрузки и ошибок" "TypeScript, React hooks" {
            tags "StateLayer"
        }
    }

    group "Слой интеграции" {
        apiClient = component "Клиент основного API" "Выполняет HTTP-запросы, передаёт файлы и преобразует ответы и ошибки в типизированные данные" "TypeScript, Fetch API" {
            tags "ClientLayer"
        }
    }
}
mobile = container "Мобильное приложение" "Позволяет диспетчеру проверять риск задержки в пути." "React Native / TypeScript"
