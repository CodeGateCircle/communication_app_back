# frozen_string_literal: true

def lower_camel_key_hash(hash)
  hash.map { |h| h.deep_transform_keys { |key| key.to_s.camelize(:lower) } }
end
