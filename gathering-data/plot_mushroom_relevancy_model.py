import keras

#model = keras.models.load_model('Cleaning Dataset/mushroom_model.keras')

#file_path = '/Users/remo/repos/mushroom_master/gathering-data/Cleaning Dataset/mushroom_relancy_model_plot.png'

model = keras.models.load_model('mushroom_masterv1_ftv1.2.keras')
file_path = '/Users/remo/repos/mushroom_master/gathering-data/mushroom_classification_model_plot.png'
keras.utils.plot_model(
    model,
    to_file=file_path,
    show_shapes=True,
    show_layer_names=True,
    rankdir='TB',
    expand_nested=False,
)