/// Supabase configuration constants for Cric-Pulse.
///
/// These are the project-level credentials for connecting to the
/// Supabase backend. The anon key is safe to embed in client apps
/// as Row-Level Security (RLS) should protect data on the server side.
class SupabaseConfig {
  SupabaseConfig._();

  /// Supabase project URL
  static const String url = 'https://dhtvhfebtscaowauupyz.supabase.co';

  /// Supabase anonymous (public) API key
  static const String anonKey =
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.'
      'eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImRodHZoZmVidHNjYW93YXV1cHl6Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3Nzc3OTkwMzgsImV4cCI6MjA5MzM3NTAzOH0.'
      'IrJeYlB-dqQpbUNqojGd_dNo0bwsKY-vyD0EbsUufic';
}
