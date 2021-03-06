#
# Copyright (c) 2016 Jakub Klama <jceel@FreeBSD.org>
# All rights reserved.
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions
# are met:
# 1. Redistributions of source code must retain the above copyright
#    notice, this list of conditions and the following disclaimer.
# 2. Redistributions in binary form must reproduce the above copyright
#    notice, this list of conditions and the following disclaimer in the
#    documentation and/or other materials provided with the distribution.
#
# THIS SOFTWARE IS PROVIDED BY THE AUTHOR AND CONTRIBUTORS ``AS IS'' AND
# ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
# IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
# ARE DISCLAIMED.  IN NO EVENT SHALL THE AUTHOR OR CONTRIBUTORS BE LIABLE
# FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
# DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS
# OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
# HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
# LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY
# OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF
# SUCH DAMAGE.
#

from libc.stdint cimport *
from posix.types cimport *
from libcpp cimport bool
from libc.stdio cimport FILE


cdef extern from "sys/nv.h":
    enum:
        NV_TYPE_NONE
        NV_TYPE_NULL
        NV_TYPE_BOOL
        NV_TYPE_NUMBER
        NV_TYPE_STRING
        NV_TYPE_NVLIST
        NV_TYPE_DESCRIPTOR
        NV_TYPE_BINARY

    ctypedef struct nvlist_t:
        pass

    nvlist_t *nvlist_create(int flags);
    void nvlist_destroy(nvlist_t *nvl);
    int	nvlist_error(const nvlist_t *nvl);
    bool nvlist_empty(const nvlist_t *nvl);
    int	nvlist_flags(const nvlist_t *nvl);
    void nvlist_set_error(nvlist_t *nvl, int error);
    nvlist_t *nvlist_clone(const nvlist_t *nvl);

    void nvlist_dump(const nvlist_t *nvl, int fd);
    void nvlist_fdump(const nvlist_t *nvl, FILE *fp);

    size_t nvlist_size(const nvlist_t *nvl);
    void *nvlist_pack(const nvlist_t *nvl, size_t *sizep);
    nvlist_t *nvlist_unpack(const void *buf, size_t size, int flags);

    int nvlist_send(int sock, const nvlist_t *nvl);
    nvlist_t *nvlist_recv(int sock);
    nvlist_t *nvlist_xfer(int sock, nvlist_t *nvl, int flags);

    const char *nvlist_next(const nvlist_t *nvl, int *typep, void **cookiep);
    const nvlist_t *nvlist_get_parent(const nvlist_t *nvl, void **cookiep);

    const nvlist_t *nvlist_get_array_next(const nvlist_t *nvl);
    bool nvlist_in_array(const nvlist_t *nvl);
    const nvlist_t *nvlist_get_pararr(const nvlist_t *nvl, void **cookiep);

    bool nvlist_exists(const nvlist_t *nvl, const char *name);
    bool nvlist_exists_type(const nvlist_t *nvl, const char *name, int type);

    bool nvlist_exists_null(const nvlist_t *nvl, const char *name);
    bool nvlist_exists_bool(const nvlist_t *nvl, const char *name);
    bool nvlist_exists_number(const nvlist_t *nvl, const char *name);
    bool nvlist_exists_string(const nvlist_t *nvl, const char *name);
    bool nvlist_exists_nvlist(const nvlist_t *nvl, const char *name);
    bool nvlist_exists_binary(const nvlist_t *nvl, const char *name);
    bool nvlist_exists_bool_array(const nvlist_t *nvl, const char *name);
    bool nvlist_exists_number_array(const nvlist_t *nvl, const char *name);
    bool nvlist_exists_string_array(const nvlist_t *nvl, const char *name);
    bool nvlist_exists_nvlist_array(const nvlist_t *nvl, const char *name);
    bool nvlist_exists_descriptor(const nvlist_t *nvl, const char *name);
    bool nvlist_exists_descriptor_array(const nvlist_t *nvl, const char *name);

    void nvlist_add_null(nvlist_t *nvl, const char *name);
    void nvlist_add_bool(nvlist_t *nvl, const char *name, bool value);
    void nvlist_add_number(nvlist_t *nvl, const char *name, uint64_t value);
    void nvlist_add_string(nvlist_t *nvl, const char *name, const char *value);
    void nvlist_add_nvlist(nvlist_t *nvl, const char *name, const nvlist_t *value);
    void nvlist_add_binary(nvlist_t *nvl, const char *name, const void *value, size_t size);
    void nvlist_add_bool_array(nvlist_t *nvl, const char *name, const bool *value, size_t nitems);
    void nvlist_add_number_array(nvlist_t *nvl, const char *name, const uint64_t *value, size_t nitems);
    void nvlist_add_string_array(nvlist_t *nvl, const char *name, const char * const *value, size_t nitems);
    void nvlist_add_nvlist_array(nvlist_t *nvl, const char *name, const nvlist_t * const *value, size_t nitems);
    void nvlist_add_descriptor(nvlist_t *nvl, const char *name, int value);
    void nvlist_add_descriptor_array(nvlist_t *nvl, const char *name, const int *value, size_t nitems);

    void nvlist_move_string(nvlist_t *nvl, const char *name, char *value);
    void nvlist_move_nvlist(nvlist_t *nvl, const char *name, nvlist_t *value);
    void nvlist_move_binary(nvlist_t *nvl, const char *name, void *value, size_t size);
    void nvlist_move_bool_array(nvlist_t *nvl, const char *name, bool *value, size_t nitems);
    void nvlist_move_string_array(nvlist_t *nvl, const char *name, char **value, size_t nitems);
    void nvlist_move_nvlist_array(nvlist_t *nvl, const char *name, nvlist_t **value, size_t nitems);
    void nvlist_move_number_array(nvlist_t *nvl, const char *name, uint64_t *value, size_t nitems);
    void nvlist_move_descriptor(nvlist_t *nvl, const char *name, int value);
    void nvlist_move_descriptor_array(nvlist_t *nvl, const char *name, int *value, size_t nitems);

    bool nvlist_get_bool(const nvlist_t *nvl, const char *name);
    uint64_t nvlist_get_number(const nvlist_t *nvl, const char *name);
    const char *nvlist_get_string(const nvlist_t *nvl, const char *name);
    const nvlist_t *nvlist_get_nvlist(const nvlist_t *nvl, const char *name);
    const void *nvlist_get_binary(const nvlist_t *nvl, const char *name, size_t *sizep);
    const bool *nvlist_get_bool_array(const nvlist_t *nvl, const char *name, size_t *nitemsp);
    const uint64_t *nvlist_get_number_array(const nvlist_t *nvl, const char *name, size_t *nitemsp);
    const char * const *nvlist_get_string_array(const nvlist_t *nvl, const char *name, size_t *nitemsp);
    const nvlist_t * const *nvlist_get_nvlist_array(const nvlist_t *nvl, const char *name, size_t *nitemsp);
    int	nvlist_get_descriptor(const nvlist_t *nvl, const char *name);
    const int *nvlist_get_descriptor_array(const nvlist_t *nvl, const char *name, size_t *nitemsp);

    bool nvlist_take_bool(nvlist_t *nvl, const char *name);
    uint64_t nvlist_take_number(nvlist_t *nvl, const char *name);
    char *nvlist_take_string(nvlist_t *nvl, const char *name);
    nvlist_t *nvlist_take_nvlist(nvlist_t *nvl, const char *name);
    void *nvlist_take_binary(nvlist_t *nvl, const char *name, size_t *sizep);
    bool *nvlist_take_bool_array(nvlist_t *nvl, const char *name, size_t *nitemsp);
    uint64_t *nvlist_take_number_array(nvlist_t *nvl, const char *name, size_t *nitemsp);
    char **nvlist_take_string_array(nvlist_t *nvl, const char *name, size_t *nitemsp);
    nvlist_t **nvlist_take_nvlist_array(nvlist_t *nvl, const char *name, size_t *nitemsp);
    int	nvlist_take_descriptor(nvlist_t *nvl, const char *name);
    int	*nvlist_take_descriptor_array(nvlist_t *nvl, const char *name, size_t *nitemsp);

    void nvlist_free(nvlist_t *nvl, const char *name);
    void nvlist_free_type(nvlist_t *nvl, const char *name, int type);

    void nvlist_free_null(nvlist_t *nvl, const char *name);
    void nvlist_free_bool(nvlist_t *nvl, const char *name);
    void nvlist_free_number(nvlist_t *nvl, const char *name);
    void nvlist_free_string(nvlist_t *nvl, const char *name);
    void nvlist_free_nvlist(nvlist_t *nvl, const char *name);
    void nvlist_free_binary(nvlist_t *nvl, const char *name);
    void nvlist_free_bool_array(nvlist_t *nvl, const char *name);
    void nvlist_free_number_array(nvlist_t *nvl, const char *name);
    void nvlist_free_string_array(nvlist_t *nvl, const char *name);
    void nvlist_free_nvlist_array(nvlist_t *nvl, const char *name);
    void nvlist_free_binary_array(nvlist_t *nvl, const char *name);
    void nvlist_free_descriptor(nvlist_t *nvl, const char *name);
    void nvlist_free_descriptor_array(nvlist_t *nvl, const char *name);
