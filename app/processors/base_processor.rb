class BaseProcessor < JSONAPI::Processor
  after_find do
    unless @result.is_a?(JSONAPI::ErrorsOperationResult)
      @result.meta[:page] = {
        count: @result.resources.count,
        total: @result.record_count
      }
    end
  end
end
