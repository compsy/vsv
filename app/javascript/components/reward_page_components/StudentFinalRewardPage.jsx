import React from 'react';
import RewardFooter from './RewardFooter';
import {
  printAsMoney
} from '../Helpers';
import I18n from '../../../../public/javascripts/i18n'
import I18nRaw from '../I18nRaw';

export default class StudentFinalRewardPage extends React.Component {
  render() {
    return (
      <div>
        <div>
          <h4>{I18n.t('pages.student_final_reward_page.header')}</h4>
          <I18nRaw t='pages.student_final_reward_page.body.top' />
          {this.renderReward()}
          <I18nRaw t='pages.student_final_reward_page.body.bottom' />
        </div>
        <div>
          <RewardFooter person={this.props.person} />
        </div>
      </div>
    );
  }

  renderReward() {
    const noEuros = 0;
    if (this.props.earnedEuros > noEuros) {
      return (
        <p className='flow-text'>
          In totaal heb je {printAsMoney(this.props.earnedEuros)} verdiend.
        </p>
      );
    }
    return <p />;
  }
}
