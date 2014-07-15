Uber::Application.routes.draw do
  root :to => 'home#index'

  match 'index' => 'home#index'
  match 'email/deliver' => 'email#deliver'
end
