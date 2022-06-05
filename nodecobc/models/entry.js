'use strict';
const {
  Model
} = require('sequelize');
module.exports = (sequelize, DataTypes) => {
  class Balance extends Model {
    /**
     * Helper method for defining associations.
     * This method is not a part of Sequelize lifecycle.
     * The `models/index` file will call this method automatically.
     */
    static associate(models) {
      // define association here
      
    }
  }
  Balance.init({
    id: {
      autoIncrement: true,
      allowNull: false,
      primaryKey: true,
      type: DataTypes.INTEGER
  },
  amount: {
      type: DataTypes.DECIMAL(10,2)
  },
  created_at: {
    type: DataTypes.DATE,
    allowNull: false,
  }
  }, {
    sequelize,
    modelName: 'balance',
    timestamps: false,
  });
  return Balance;
};