'use strict';
const {
  Model
} = require('sequelize');
module.exports = (sequelize, DataTypes) => {
  class AppClient extends Model {
    /**
     * Helper method for defining associations.
     * This method is not a part of Sequelize lifecycle.
     * The `models/index` file will call this method automatically.
     */
    static associate(models) {
      // define association here
      AppClient.hasMany(models.balance, {
        foreignKey: 'dni'
      });
    }
  }
  AppClient.init({
    dni: {
      allowNull: false,
      primaryKey: true,
      type: DataTypes.STRING(8)
  },
  name: {
      unique: true,
      type: DataTypes.STRING(48)
  },
  created_at: {
    type: DataTypes.DATE,
    allowNull: false,
  }
  }, {
    sequelize,
    modelName: 'app_client',
    timestamps: false,
  });
  return AppClient;
};