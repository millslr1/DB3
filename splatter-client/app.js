(function() { // We use this anonymous function to create a closure.

	var app = angular.module('splatter-web', ['ngResource']);

	app.factory("User", function($resource) {
		return $resource('http://mills.sqrawler.com/api/users/:id.json', {id: '@id'}, 
			{
				'update': { method: 'PUT' },
				'save': { method: 'POST' },
				'delete': { method: 'DELETE' },
				'getSplatts': { method: 'GET', url:'http://mills.sqrawler.com/api/users/splatts-feed/:id.json' },
				'addSplatt': { method: 'POST', url:'http://mills.sqrawler.com/api/splatts.json' },
				'newFollow': { method: 'POST', url: 'http://mills.sqrawler.com/api/users/follows/' },
				'unfollowUser': { method: 'DELETE', url: 'http://mills.sqrawler.com/api/users/follows/' }
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
				password: this.data.password,
				blurb: this.data.blurb
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
			User.$delete({id: this.data.id});
		};

		this.feed = function() {
			User.$getSplatts({id:this.activeUser.id});
		};

		this.newSplatt = function() {
			User.$addSplatt = ({splatt: {body:this.data.body, user_id: this.activeUser.id}});
			this.data = {};
		};

		this.follow = function() {
			User.$newFollow({id:this.activeUser.id, follows_id:this.data.id});
			this.data = {};
		};

		this.unfollow = function () {
			User.$unfollowUser({id:this.activeUser.id, follows_id:this.data.id});
			this.data = {};

		}

	});

})();
