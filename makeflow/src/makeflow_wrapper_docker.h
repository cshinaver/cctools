
/*
Copyright (C) 2015- The University of Notre Dame
This software is distributed under the GNU General Public License.
See the file COPYING for details.
*/

#ifndef MAKEFLOW_WRAPPER_DOCKER_H
#define MAKEFLOW_WRAPPER_DOCKER_H

#define CONTAINER_SH "docker.wrapper.sh"

/*
This module implements garbage collection on the dag.
Files that are no longer needed as inputs to any rules
may be removed, according to a variety of criteria.
*/

typedef enum {
	CONTAINER_MODE_NONE,
	CONTAINER_MODE_DOCKER,
	// CONTAINER_MODE_ROCKET etc
} container_mode_t;

void makeflow_wrapper_docker_init( struct makeflow_wrapper *w, char *container_image, char *image_tar );

#endif
