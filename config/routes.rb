Rails.application.routes.draw do
  scope '/system', :module => 'system_metrics' do
    get 'metrics/admin' => 'metrics#admin', :as => 'system_metrics_admin'
    get 'metrics/category/:category' => 'metrics#category', :as => 'system_metrics_category'
    resources :metrics, :only => [:index, :show, :destroy]
  end
end
