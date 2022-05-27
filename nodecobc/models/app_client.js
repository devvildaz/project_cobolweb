'use strict';
const {
  Model
} = require('sequelize');
module.exports = (sequelize, DataTypes) => {
  class App_client extends Model {
    /**
     * Helper method for defining associations.
     * This method is not a part of Sequelize lifecycle.
     * The `models/index` file will call this method automatically.
     */
    static associate(models) {
      // define association here
      
    }
  }
  App_client.init({
    dni: {
      allowNull: false,
      primaryKey: true,
      type: Sequelize.STRING(8)
  },
  name: {
      unique: true,
      type: Sequelize.STRING(48)
  },
  }, {
    sequelize,
    modelName: 'app_clients',
  });
  return App_client;
};