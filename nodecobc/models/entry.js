'use strict';
const {
  Model
} = require('sequelize');
module.exports = (sequelize, DataTypes) => {
  class Entry extends Model {
    /**
     * Helper method for defining associations.
     * This method is not a part of Sequelize lifecycle.
     * The `models/index` file will call this method automatically.
     */
    static associate(models) {
      // define association here
      Entry.belongsTo(models.App_client, 
        {
          foreignKey: 'dni',
          as: 'client_dni'
      });
    }
  }
  Entry.init({
    id: {
      autoIncrement: true,
      allowNull: false,
      primaryKey: true,
      type: Sequelize.INTEGER
  },
  dni: {
      type: Sequelize.STRING(8)
  },
  amount: {
      type: DataTypes.DECIMAL(10,2)
  },
  }, {
    sequelize,
    modelName: 'balances',
  });
  return Entry;
};