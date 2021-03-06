﻿//================================================================================
// Filename: Main.as
// Authour: Jacky Fong
// Description:
// Facebook API Sample
//================================================================================

package
{
	import flash.display.Sprite;
	import flash.display.MovieClip;
	import flash.text.TextField;
	import flash.events.MouseEvent;
	import flash.events.Event;
	import fl.controls.List;

	import com.pbking.facebook.Facebook;
	import com.pbking.facebook.delegates.users.GetUserInfo_delegate;
	import com.pbking.facebook.data.users.FacebookUser;
	import com.pbking.facebook.data.users.UserFields;
	import com.pbking.facebook.delegates.friends.GetFriends_delegate;		
	
	/**
	* FbTest communicates with Facebook API
	*/	
	public class FlashCS3Example extends Sprite
	{
		private var _fb:Facebook;		
		private var _api_key:String = "xxxx";		
		private var _secret:String = "xxxx";
		
		private var _friendList:Array;
		private var curUser:FacebookUser;
	
		public function FlashCS3Example()
		{
			txtLog.appendText( "FbTest class\n" );
			_init();
		}
		
		/**
		 * Called when the application is ready
		 */
		private function _init():void
		{
			// listeners
			mcValidate.addEventListener( MouseEvent.CLICK, _onMcValidateClick );
			lstFriends.addEventListener( Event.CHANGE, _onLstFriendsChange );
			mcSend.addEventListener( MouseEvent.CLICK, _onMcSendClick );
			
			// facebook
			_fb = Facebook.instance;
			_fb.addEventListener( Event.COMPLETE, _onFacebookReady );
			
			txtLog.appendText( "start desktop session\n" );
			txtLog.appendText( "must wait for the facebook login pop-up window and authenticated\n" );
			_fb.startDesktopSession( _api_key, _secret );		
		}

		private function _onMcValidateClick( evt:MouseEvent ):void
		{
			txtLog.appendText( "validate desktop session\n" );
			_fb.validateDesktopSession();		
		}
		
		private function _onLstFriendsChange( evt:Event ):void
		{
			txtLog.appendText( evt.target.selectedItem.data.name + " selected\n" );
			curUser = evt.target.selectedItem.data;
		}
		
		private function _onMcSendClick( evt:MouseEvent ):void
		{
			txtLog.appendText( "send notification to " + curUser.name + "\n" );
			txtLog.appendText( "message: " + txtMsg.text + "\n" );
			_fb.notifications.send( "says: " + txtMsg.text, [ curUser ] );
		}
		
		private function _onFacebookReady( evt:Event ):void
		{
			txtLog.appendText( "Facebook ready\n" );
			
			if( _fb.isConnected ) {
				txtLog.appendText( "Facebook connected\n" );
				_fb.friends.getFriends( _onGetFriends );
			}
			else {
				txtLog.appendText( "Facebook not connected: " + _fb.connectionErrorMessage + "\n" );
			}			
		}

		/**
		 * All calls to the Facebook server return a FacebookDelegate in the event.
		 * The results of the calls are public properties of that specific delegate.
		 * Here we are turning around and getting some info for all of our friends.
		 */
		private function _onGetFriends( evt:Event ):void
		{
			var delegate:GetFriends_delegate = evt.target as GetFriends_delegate;
			_fb.users.getInfo( delegate.friends, [ UserFields.name, UserFields.pic_big ], _onGetInfo );
		}
		
		private function _onGetInfo( evt:Event ):void
		{
			var delegate:GetUserInfo_delegate = evt.target as GetUserInfo_delegate;
			var user:FacebookUser;
			_friendList = delegate.users;
			
			for( var i=0; i<_friendList.length; i++ ) {
				user = FacebookUser( _friendList[i] );
				lstFriends.addItem( { label:user.name + " (" + user.uid + ")", data:user } );
			}
		}
	}
}