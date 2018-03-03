class NotesController < ApplicationController
  before_action :set_note, only: [:show, :edit, :update, :destroy, :edit_disclosures, :update_disclosures]

  # GET /notes
  # GET /notes.json
  def index
    @notes = Note.disclosed_to_or_owned_by(current_user)
                 .order(:updated_at)
  end

  # GET /notes/1
  # GET /notes/1.json
  def show
  end

  # GET /notes/new
  def new
    @note = Note.new
  end

  # GET /notes/1/edit
  def edit
  end

  # POST /notes
  # POST /notes.json
  def create
    @note = Note.new(note_params)
    @note.owner = current_user

    respond_to do |format|
      if @note.save
        format.html { redirect_to @note, notice: 'Note was successfully created.' }
        format.json { render :show, status: :created, location: @note }
      else
        format.html { render :new }
        format.json { render json: @note.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /notes/1
  # PATCH/PUT /notes/1.json
  def update
    respond_to do |format|
      if @note.update(note_params)
        format.html { redirect_to @note, notice: 'Note was successfully updated.' }
        format.json { render :show, status: :ok, location: @note }
      else
        format.html { render :edit }
        format.json { render json: @note.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /notes/1
  # DELETE /notes/1.json
  def destroy
    @note.destroy
    respond_to do |format|
      format.html { redirect_to notes_url, notice: 'Note was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def edit_disclosures
    @note.rest_disclosures_size.times do
      @note.disclosures.build
    end
  end

  def update_disclosures
    respond_to do |format|
      if @note.update(note_disclosures_params)
        format.html { redirect_to @note, notice: 'Disclosures was successfully updated.' }
        format.json { render :show, status: :ok, location: @note }
      else
        format.html { render :edit }
        format.json { render json: @note.errors, status: :unprocessable_entity }
      end
    end

  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_note
      @note = Note.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def note_params
      params.require(:note).permit(:title, :text)
    end

    def note_disclosures_params
      _note_params = params.require(:note).permit(disclosures_attributes: [:id, :group_id])
      _note_params["disclosures_attributes"].each do | k, v |
        v["_destroy"] = true if v["group_id"].blank?
      end
      _note_params

    end

end
