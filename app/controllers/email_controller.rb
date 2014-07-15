class EmailController < ApplicationController

  def deliver
    MailerService.new(params).deliver
    redirect_to ''
  end

end