Uber::Application.routes.draw do
  root :to => 'home#index'

  match 'email/deliver' => 'email#deliver'
end
