module Avocado
  class Middleware::RequestSerialization

    def call(example, request, response)
      @request = request
      Avocado::Cache.json.merge! request: serialize(@request)
      yield
    end

    private

      def serialize(request)
        {
          method:  request.method,
          path:    request.path,
          params:  request.params.except('controller', 'action').to_h,
          headers: headers.compact
        }
      end

      def headers
        hash = {}
        Avocado::Config.headers.each do |name|
          hash[name] = @request.headers.env["HTTP_#{name.tr('-', '_')}".upcase]
        end
        hash
      end

  end
end