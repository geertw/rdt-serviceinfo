#!/usr/bin/env python

"""
IFF/ARNU service scheduler
Copyright (C) 2015 Geert Wirken

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see <http://www.gnu.org/licenses/>.
"""

import logging
import logging.config
import argparse
from datetime import datetime
import isodate
import sys

import serviceinfo.iff
import serviceinfo.service_store
import serviceinfo.service_filter
import serviceinfo.common
import serviceinfo.util
from serviceinfo import service_filter


def get_current_servicedate(date='TODAY'):
    """
    Get the current servicedate. Returns a datetime.date object.
    """

    logger = logging.getLogger(__name__)

    # Determine service date
    if date == 'TODAY':
        service_date = serviceinfo.util.get_service_date(datetime.now())
    else:
        # Parse date
        try:
            service_date = isodate.isodates.parse_date(date)
        except (isodate.ISO8601Error, ValueError) as exception:
            logger.error('Could not parse service date: %s', exception)
            service_date = None
        
        if service_date != None:
            logger.info('Custom service date used (%s)',
                service_date.strftime('%Y-%m-%d'))

    return service_date

def load_schedule(service_date):
    """
    Retrieve the schedule from IFF.

    Args:
        service_date (date): Date for which to retrieve the schedule

    Returns:
        list of scheduled services (containing Service objects)
    """

    logger = logging.getLogger(__name__)

    logger.debug('Getting services for %s', service_date)
    iff = serviceinfo.iff.IffSource(
        serviceinfo.common.configuration['iff_database'])
    services = iff.get_services_date(service_date)

    logger.info('Found %s scheduled services on %s',
        len(services), service_date.strftime('%Y-%m-%d'))

    # Get services:
    schedule = iff.get_services_details(services, service_date)

    logger.info('Loaded %s services', len(services))

    return schedule

def filter_schedule(schedule, filter_config):
    """
    Filter the list of scheduled services according to the configuration
    """

    logger = logging.getLogger(__name__)
    logger.info('Filtering schedule')

    filtered_schedule = []

    for service in schedule:
        if service_filter.is_service_included(service, filter_config):
            filtered_schedule.append(service)
        else:
            logger.debug("Ignoring service %s/%s" % (service.company_code, service.servicenumber))

    return filtered_schedule


def store_schedule(schedule):
    """
    Store a schedule to the schedule store.

    Args:
        schedule (list): List of scheduled services
    """

    logger = logging.getLogger(__name__)

    logger.debug('Storing schedule to store')
    store = serviceinfo.service_store.ServiceStore(
        serviceinfo.common.configuration['schedule_store'])

    store.store_services(schedule, store.TYPE_SCHEDULED)

    logger.info('Services stored to schedule')


def main():
    """
    Main loop
    """

    # Initialize argparse
    parser = argparse.ArgumentParser(
        description='RDT Serviceinfo / scheduler')

    parser.add_argument('-c', '--config', dest='configFile',
        default='config/serviceinfo.yaml',
        action='store', help='Configuration file')

    parser.add_argument('-d', '--servicedate', dest='servicedate',
        default='TODAY', action='store', help='Service date')

    args = parser.parse_args()

    # Load configuration:
    serviceinfo.common.load_config(args.configFile)
    serviceinfo.common.setup_logging('scheduler')

    # Get logger instance:
    logger = logging.getLogger(__name__)
    logger.info('Scheduler starting')

    servicedate = get_current_servicedate(args.servicedate)

    if servicedate == None:
        logger.error("No valid service date, aborting.")
        sys.exit(1)

    schedule = load_schedule(servicedate)
    schedule = filter_schedule(schedule,
        serviceinfo.common.configuration['scheduler']['filter'])
    store_schedule(schedule)

if __name__ == "__main__":
    main()
