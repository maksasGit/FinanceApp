class DefaultSerializer
  include JSONAPI::Serializer
  # This serializer is intended for cases where an empty data collection needs to be processed.
end
