component regulationService "RegulationComponents" {
    title "L3 — Компоненты сервиса регламентов и аналитики"
    include api regulationController reportController regulationIngestion versionManager conditionValidator indexPublisher delayAnalytics regulationRepository documentStore analyticsReader database objects vectors analytics
    autoLayout lr
}
