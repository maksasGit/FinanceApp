class SidekiqController < ApplicationController
  skip_before_action :authorized

  def index
    jobs = Sidekiq::Cron::Job.all.map do |job|
      {
        name: job.name,
        cron: job.cron,
        class: job.klass,
        last_enqueue_time: job.last_enqueue_time,
        status: job.status,
        description: job.description,
      }
    end

    render json: jobs, status: :ok
  end

  def destroy
    job_name = params[:name]
    job = Sidekiq::Cron::Job.find(job_name)

    if job
      job.destroy
      render json: { message: "Deleted cron job '#{job_name}'" }
    else
      render json: { error: "Cron job '#{job_name}' not found" }, status: :not_found
    end
  end

  def destroy_all
    Sidekiq::Cron::Job.all.each(&:destroy)
    render json: { message: 'All cron jobs deleted' }
  end
end