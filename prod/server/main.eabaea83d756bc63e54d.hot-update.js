exports.id = "main";
exports.modules = {

/***/ "./src/server/server.js":
/*!******************************!*\
  !*** ./src/server/server.js ***!
  \******************************/
/*! exports provided: default */
/***/ (function(module, __webpack_exports__, __webpack_require__) {

"use strict";
eval("__webpack_require__.r(__webpack_exports__);\n/* harmony import */ var _build_contracts_FlightSuretyApp_json__WEBPACK_IMPORTED_MODULE_0__ = __webpack_require__(/*! ../../build/contracts/FlightSuretyApp.json */ \"./build/contracts/FlightSuretyApp.json\");\nvar _build_contracts_FlightSuretyApp_json__WEBPACK_IMPORTED_MODULE_0___namespace = /*#__PURE__*/__webpack_require__.t(/*! ../../build/contracts/FlightSuretyApp.json */ \"./build/contracts/FlightSuretyApp.json\", 1);\n/* harmony import */ var _config_json__WEBPACK_IMPORTED_MODULE_1__ = __webpack_require__(/*! ./config.json */ \"./src/server/config.json\");\nvar _config_json__WEBPACK_IMPORTED_MODULE_1___namespace = /*#__PURE__*/__webpack_require__.t(/*! ./config.json */ \"./src/server/config.json\", 1);\n/* harmony import */ var web3__WEBPACK_IMPORTED_MODULE_2__ = __webpack_require__(/*! web3 */ \"web3\");\n/* harmony import */ var web3__WEBPACK_IMPORTED_MODULE_2___default = /*#__PURE__*/__webpack_require__.n(web3__WEBPACK_IMPORTED_MODULE_2__);\n/* harmony import */ var express__WEBPACK_IMPORTED_MODULE_3__ = __webpack_require__(/*! express */ \"express\");\n/* harmony import */ var express__WEBPACK_IMPORTED_MODULE_3___default = /*#__PURE__*/__webpack_require__.n(express__WEBPACK_IMPORTED_MODULE_3__);\nfunction asyncGeneratorStep(gen, resolve, reject, _next, _throw, key, arg) { try { var info = gen[key](arg); var value = info.value; } catch (error) { reject(error); return; } if (info.done) { resolve(value); } else { Promise.resolve(value).then(_next, _throw); } }\n\nfunction _asyncToGenerator(fn) { return function () { var self = this, args = arguments; return new Promise(function (resolve, reject) { var gen = fn.apply(self, args); function _next(value) { asyncGeneratorStep(gen, resolve, reject, _next, _throw, \"next\", value); } function _throw(err) { asyncGeneratorStep(gen, resolve, reject, _next, _throw, \"throw\", err); } _next(undefined); }); }; }\n\n\n\n\n // require(\"@babel/core\").transform(\"code\", {\n//   plugins: [\"@babel/plugin-transform-async-to-generator\"]\n// });\n\nvar config = _config_json__WEBPACK_IMPORTED_MODULE_1__['localhost'];\nvar web3 = new web3__WEBPACK_IMPORTED_MODULE_2___default.a(new web3__WEBPACK_IMPORTED_MODULE_2___default.a.providers.WebsocketProvider(config.url.replace('http', 'ws')));\nweb3.eth.defaultAccount = web3.eth.accounts[0];\nvar flightSuretyApp = new web3.eth.Contract(_build_contracts_FlightSuretyApp_json__WEBPACK_IMPORTED_MODULE_0__.abi, config.appAddress); // const statusCodeUnknown = 0;\n// const statusCodeOnTime = 10;\n// const statusCodeLateAirline = 20;\n// const statusCodeLateWeather = 30;\n// const statusCodeLateTechnical = 40;\n// const statusCodeLateOther = 50;\n\nvar statusCodes = [0, 10, 20, 30, 40, 50];\nvar oracleCount = 1;\nconfig.oracleCount;\n\nfunction getRandomStatus() {\n  var randomIndex = Math.floor(Math.random() * 6);\n  return statusCodes[randomIndex];\n}\n\nfunction registerOracles() {\n  return _registerOracles.apply(this, arguments);\n}\n\nfunction _registerOracles() {\n  _registerOracles = _asyncToGenerator(\n  /*#__PURE__*/\n  regeneratorRuntime.mark(function _callee() {\n    var oracleFee, _a, result;\n\n    return regeneratorRuntime.wrap(function _callee$(_context) {\n      while (1) {\n        switch (_context.prev = _context.next) {\n          case 0:\n            console.log(\"registerOracles *******\");\n            console.log(\"config.appAddress: \" + config.appAddress);\n            console.log(\"flightSuretyApp: \" + flightSuretyApp);\n            _context.next = 5;\n            return flightSuretyApp.REGISTRATION_FEE;\n\n          case 5:\n            oracleFee = _context.sent;\n            console.log(\"oracleFee: \" + oracleFee);\n            _a = 1;\n\n          case 8:\n            if (!(_a <= oracleCount)) {\n              _context.next = 18;\n              break;\n            }\n\n            _context.next = 11;\n            return flightSuretyApp.registerOracle({\n              from: accounts[_a],\n              value: oracleFee\n            });\n\n          case 11:\n            _context.next = 13;\n            return flightSuretyApp.getOracle.call(accounts[_a]);\n\n          case 13:\n            result = _context.sent;\n            console.log(\"Oracle registred: \".concat(result[0], \", \").concat(result[1], \", \").concat(result[2])); // for (let a = 1; a <= 20; a++) {\n            //   console.log(`a: ${a}`);\n\n          case 15:\n            _a++;\n            _context.next = 8;\n            break;\n\n          case 18:\n          case \"end\":\n            return _context.stop();\n        }\n      }\n    }, _callee);\n  }));\n  return _registerOracles.apply(this, arguments);\n}\n\nflightSuretyApp.events.OracleRequest({\n  fromBlock: 0\n}, function (error, event) {\n  if (error) {\n    console.log(error);\n  } else {\n    var flightStatus = getRandomStatus();\n    console.log(\"flighStatus: \" + flightStatus);\n    flightSuretyApp.submitOracleResponse(event.args.index, event.args.airline, event.args.flight, event.args.timestamp, flightStatus, {\n      from: accounts[a]\n    });\n  }\n\n  console.log(event);\n});\nvar app = express__WEBPACK_IMPORTED_MODULE_3___default()();\napp.get('/api', function (req, res) {\n  res.send({\n    message: 'An API for use with your Dapp!'\n  });\n});\nconsole.log('********* test *********');\nregisterOracles().then(function () {\n  console.log(\"** registerOracles called **\");\n})[\"catch\"](function (error) {\n  console.log(error);\n});\n/* harmony default export */ __webpack_exports__[\"default\"] = (app);\n\n//# sourceURL=webpack:///./src/server/server.js?");

/***/ }),

/***/ "@babel/core":
false

};