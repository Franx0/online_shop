module Response
  def render_json(object, status = nil, args: {})
    if object.try(:errors).present?
      render json: { errors: object.errors.try(:messages) || object.errors },
             status: :unprocessable_entity
    else
      render json: object, status: (status || :ok), **args
    end
  end
end
