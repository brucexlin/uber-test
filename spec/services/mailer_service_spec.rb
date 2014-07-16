require 'rails_helper'

describe MailerService do

  context 'when correct params are received' do
    it 'delivers the email and return true' do
      params = { name: 'test_user', to: 'test@test.com', subject: 'test', content: 'test content' }
      expect(MailerService.new(params).deliver).to eq(true)
    end

    it 'delivers the email with optional params missing' do
      params = { to: 'test@test.com', content: 'test content' }
      expect(MailerService.new(params).deliver).to eq(true)
    end
  end

  context 'when incorrect params are received' do
    context 'when email is missing' do
      it 'logs the error message and returns false' do
        params = { name: 'test_user', subject: 'test', content: 'test content' }
        expect(Rails.logger).to receive(:error).with("Email is missing")
        expect(MailerService.new(params).deliver).to eq(false)
      end
    end

    context 'when content is missing' do
      it 'logs the error message and returns false' do
        params = { name: 'test_user', to: 'test@test.com', subject: 'test' }
        expect(Rails.logger).to receive(:error).with("Content is missing")
        expect(MailerService.new(params).deliver).to eq(false)
      end
    end

    context 'when email format is incorrect' do
      it 'logs the error message and returns false' do
        params = { name: 'test_user', to: 'test', subject: 'test', content: 'test content' }
        expect(Rails.logger).to receive(:error).with("Email format is invalid")
        expect(MailerService.new(params).deliver).to eq(false)

        params = { name: 'test_user', to: 'test@test', subject: 'test', content: 'test content' }
        expect(Rails.logger).to receive(:error).with("Email format is invalid")
        expect(MailerService.new(params).deliver).to eq(false)
      end
    end
  end

end