(function() { // We use this anonymous function to create a closure.

	var app = angular.module('splatter-web', ['ngResource']);

	app.factory("User", function($resource) {
		return $resource('http://mills.sqrawler.com/api/users/:id.json', {id: '@id'}, 
			{
				'update': { method: 'PUT' },
				'create': { method: 'POST' },
				'delete': { method: 'DELETE' }
			});
	});
	
	app.controller('UserController', function(User) {

		this.getUser = function(i) {
			return User.get({id: i});
		};

		this.userLogin = function() {
			this.activeUser = this.getUser(this.data.id);
			this.data = {};
		};

		this.createUser = function() {
			user = new User({name: this.data.name,
				email: this.data.email,
				password: this.data.password
			});
			user.$save();
		};

		this.updateUser = function() {
			this.activeUser.name = this.data.name;
			this.activeUser.blurb = this.data.blurb;
			this.activeUser.$update({id: this.activeUser.id});
			this.data = {};
		};

		this.deleteUser = function() {
			User.delete({id: this.data.id});
		};

	});

})();
