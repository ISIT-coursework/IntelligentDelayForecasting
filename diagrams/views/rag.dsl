component rag "RagComponents" {
    include ragApi ragOrchestrator queryEncoder regulationSearch promptBuilder llmClient answerBuilder api vectors llmProvider
    autoLayout lr
}