import '../stylesheets/app.scss'

const images = require.context('../assets/img', true)
const imagePath = (name) => images(name, true)

// Support component names relative to this directory:
var componentRequireContext = require.context("components", true);
var ReactRailsUJS = require("react_ujs");
ReactRailsUJS.useContext(componentRequireContext);
