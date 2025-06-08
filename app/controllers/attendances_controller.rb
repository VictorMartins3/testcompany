class AttendancesController < ApplicationController
  def create
    attendance = Attendance.new(attendance_params)
    if attendance.save
      render json: attendance.as_json, status: :created
    else
      render json: { errors: attendance.errors }, status: :unprocessable_entity
    end
  end

  private

  def attendance_params
    params.require(:attendance).permit(:participant_id, :talk_id)
  end
end
