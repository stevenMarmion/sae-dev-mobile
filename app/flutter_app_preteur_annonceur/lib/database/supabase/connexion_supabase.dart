// ignore: depend_on_referenced_packages
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseConnexion {

  static initaliseConnexion() async {
      await Supabase.initialize(
        url: 'https://meubemsketmbaswvbxgb.supabase.co',
        anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im1ldWJlbXNrZXRtYmFzd3ZieGdiIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MTA0MTQ3MjAsImV4cCI6MjAyNTk5MDcyMH0.eYfLjAuud9ea8sCPt9XETUPdbglymnBwAcXmDEhyJGs',
      );
  }
}