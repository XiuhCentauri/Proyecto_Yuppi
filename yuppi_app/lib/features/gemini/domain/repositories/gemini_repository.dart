import "package:flutter/material.dart";
import "package:yuppi_app/features/gemini/data/models/gemini_fact_model.dart";
import "package:yuppi_app/features/gemini/domain/entities/gemini_response.dart";

abstract class GeminiRepository {
  Future<GeminiResponse> fetchGeneratedText(String prompt);
  Future<bool> saveRegistPyC(GeminiFactModel geminiFact);
}
