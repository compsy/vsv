import React from 'react';
import I18n from '../../../../public/javascripts/i18n';

export default class DefaultRewardPage extends React.Component {
  render() {
    return (
      <div className='section'>
        <p className='flow-text'>
          {I18n.t('pages.klaar.header')}
        </p>
      </div>
    );
  }
}
