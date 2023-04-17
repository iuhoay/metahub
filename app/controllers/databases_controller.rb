class DatabasesController < ApplicationController
  before_action :set_database, only: [:show, :edit, :update, :destroy, :sync_schemas]

  def index
    authorize Database
    @databases = policy_scope(Database)
  end

  def new
    authorize Database
    @database = Database.new
  end

  def create
    authorize Database
    @database = Database.new(database_params)
    if @database.save
      redirect_to databases_path
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @database.update(database_params)
      redirect_to databases_path
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def show
    @database_schemas = @database.schemas
  end

  def sync_schemas
    @database.sync_schemas
    redirect_to database_path(@database)
  end

  private

  def database_params
    params.require(:database).permit(:name, :kind, :host, :port, :description, :username, :password)
  end

  def set_database
    @database = Database.find(params[:id])
    authorize @database.become
  end
end
