module HeaderType
  HTTP_AUTH = 1
  CONTENT_TYPE = 2
end

def prepare_auth_token
  creds = []
  
  File.foreach('config/.access') do |line|
    creds.append(line.split('=').last.strip)
  end

  Base64.encode64(creds.join(':'))
end

def prepare_headers(type = nil)
  case type
  when HeaderType::HTTP_AUTH
    {'HTTP_AUTHORIZATION' => "Basic #{prepare_auth_token}" }
  when HeaderType::CONTENT_TYPE
    {'CONTENT_TYPE' => 'application/json'}
  else
    prepare_headers(HeaderType::HTTP_AUTH).merge(prepare_headers(HeaderType::CONTENT_TYPE))
  end
end
