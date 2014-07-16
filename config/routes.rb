Uber::Application.routes.draw do
  root :to => 'home#index'

  post 'email/deliver' => 'email#deliver'
end
