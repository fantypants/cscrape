
import React from 'react'

class Navbar extends React.Component {
  render() {
    let avatarURL = 'https://rentnjoy.com/development/wp-content/uploads/1457/86/analyst-placeholder-avatar.png'
    let logoURL = ''
    return (
      <div className='navbar'>
        <div className='header_content'>
          <a>
            <img src={logoURL} />
          </a>
          <div className='user_profile'>
            <a href="">
              <div className='login-button user_profile'>
                <span> User History </span>
                <span style={{ width: 5 }}/>
                <span className='fa fa-user' />
              </div>
            </a>
          </div>
        </div>
      </div>
    )
  }
}

export default Navbar
