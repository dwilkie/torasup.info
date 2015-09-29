class PhoneNumberQueriesController < ApplicationController
  def index
    @phone_number_query = PhoneNumberQuery.new(params[:q])
    @phone_number_query.execute
    decorate
  end

  private

  def decorate
    @result = PhoneNumberQueryDecorator.new(@phone_number_query)
  end
end
