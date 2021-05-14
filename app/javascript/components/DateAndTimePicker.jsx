import React, { useState } from 'react'
import ReactDatePicker from 'react-datepicker'
import classNames from 'classnames'
import moment from 'moment'
import { dateAndTimePickerDefaultOptions, backendDateFormat, backendHoursFormat, backendMinutesFormat } from './Constants'
import { nl, enUS } from 'date-fns/locale'
import I18n from '../../../public/javascripts/i18n'

const DateAndTimePicker = props => {
  const calculateStartDate = () => {
    if (props.today) return moment().set({ minute: 0 }).toDate()
    if (props.default_date) return moment(props.default_date).toDate()
    return undefined
  }
  const [startDate, setStartDate] = useState(calculateStartDate())

  const calculateMin = () => {
    if (!props.min || props.min.length === 0) return undefined
    if (props.max && (props.max === true || props.max === false)) {
      // if min is a number
      if (parseInt(props.min).toString() === props.min.toString()) {
        const minNum = parseInt(props.min)
        if (minNum > 0) return moment().add(minNum, 'days').toDate()
        if (minNum < 0) return moment().subtract(minNum, 'days').toDate()
        return moment().toDate()
      }
    }
    return moment(props.min).toDate()
  }

  const calculateMax = () => {
    if (!props.max || props.max.length === 0) return undefined
    if (props.max === true) return moment().toDate()
    return moment(props.max).toDate()
  }

  return (
    <div className='input-field'>
      <ReactDatePicker
        id={props.id}
        {...dateAndTimePickerDefaultOptions}
        selected={startDate}
        onChange={date => setStartDate(date)}
        minDate={calculateMin()}
        maxDate={calculateMax()}
        required={props.required}
        locale={(props.locale && props.locale === 'en') ? enUS : nl }
        timeCaption={I18n.t('time', { locale: props.locale })}
      />
      <label htmlFor={props.id} className={classNames('input-label', startDate && 'active')}>{props.placeholder}</label>
      {startDate && (
        <>
          <input type='hidden' name={props.name} value={moment(startDate).format(backendDateFormat)} />
          <input type='hidden' name={props.hours_name} value={moment(startDate).format(backendHoursFormat)} />
          <input type='hidden' name={props.minutes_name} value={moment(startDate).format(backendMinutesFormat)} />
        </>
      )}
    </div>
  )
}

// noinspection JSUnusedGlobalSymbols
export default DateAndTimePicker
