# y_infra — TODO

## Network
- [ ] RetryInterceptor — genel retry mekanizması
  - Configurable `maxRetries` (default: 3)
  - Configurable `retryDelay` with exponential backoff
  - Retry on specific status codes (500, 502, 503, 408)
  - Retry on timeout (DioExceptionType.connectionTimeout, receiveTimeout, sendTimeout)
  - Retry on connection error
  - Skip retry for non-idempotent methods (POST, PUT, DELETE) unless explicitly allowed
