# we use Exactor api to calculate tax
# more info can be found here http://www.exactor.com/wp-content/uploads/2012/11/Exactor_Transaction_API.pdf

EBAY = YAML.load_file("#{Rails.root}/config/ebay.yml")[Rails.env]