directory '/Users/tandeningklement/Desktop/Parser/xfers-swagger-api/app/controllers'

desc "generate oas"
task :generate => :environment do
  GenerateController.new("https://api.swaggerhub.com/apis/xfers/xfers-api/3/swagger.json").generate
end
