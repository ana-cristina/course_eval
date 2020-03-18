json.array!(@evaluation_sessions) do |evaluation_session|
  json.extract! evaluation_session, :id
  json.url evaluation_session_url(evaluation_session, format: :json)
end
